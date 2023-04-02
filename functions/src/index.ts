/* eslint-disable import/no-unresolved */
import { messaging, auth } from "firebase-admin";

import * as functions from "firebase-functions";
import { initializeApp } from "firebase-admin/app";
import {
  getFirestore,
  FieldValue,
  Timestamp,
} from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { getMessaging } from "firebase-admin/messaging";
import { getRemoteConfig } from "firebase-admin/remote-config";
import { StreamChat } from "stream-chat";
import { defineSecret } from "firebase-functions/params";
import { HttpsError } from "firebase-functions/v1/auth";

import Stripe from "stripe";
import { Booking } from "./models";

const app = initializeApp();

const streamKey = defineSecret("STREAM_KEY");
const streamSecret = defineSecret("STREAM_SECRET");

// const stripeKey = defineSecret("STRIPE_TEST_KEY");
// const stripePublishableKey = defineSecret("STRIPE_PUBLISHABLE_TEST_KEY");
const stripeKey = defineSecret("STRIPE_KEY");
const stripePublishableKey = defineSecret("STRIPE_PUBLISHABLE_KEY");

const db = getFirestore(app);
const storage = getStorage(app);
const fcm = getMessaging(app);
const remote = getRemoteConfig(app);

const usersRef = db.collection("users");
const loopsRef = db.collection("loops");
const activitiesRef = db.collection("activities");
// const followingRef = db.collection("following");
const followersRef = db.collection("followers");
// const likesRef = db.collection("likes");
const commentsRef = db.collection("comments");
const loopCommentsGroupRef = db.collectionGroup("loopComments");
const feedsRef = db.collection("feeds");
// const badgesRef = db.collection("badges");
// const badgesSentRef = db.collection("badgesSent");
const tokensRef = db.collection("device_tokens")

// const loopLikesSubcollection = "loopLikes";
// const loopCommentsSubcollection = "loopComments";
const loopsFeedSubcollection = "userFeed";


const _getFileFromURL = (fileURL: string): string => {
  const fSlashes = fileURL.split("/");
  const fQuery = fSlashes[fSlashes.length - 1].split("?");
  const segments = fQuery[0].split("%2F");
  const fileName = segments.join("/");

  return fileName;
};

const _authenticated = (context: functions.https.CallableContext) => {
  // Checking that the user is authenticated.
  if (!context.auth) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "failed-precondition",
      "The function must be called while authenticated."
    );
  }
};

// const _createUser = async (data: {
//   id: string;
//   email?: string;
//   username?: string;
//   bio?: string;
//   profilePicture?: string;
//   location?: string;
//   onboarded?: boolean;
//   loopsCount?: number;
//   badgesCount?: number;
//   shadowBanned?: boolean;
//   accountType?: string;
//   twitterHandle?: string; 
//   instagramHandle?: string;
//   tiktokHandle?: string;
//   soundcloudHandle?: string;
//   youtubeChannelId?: string ;
//   pushNotificationsLikes?: boolean;
//   pushNotificationsComments?: boolean;
//   pushNotificationsFollows?: boolean;
//   pushNotificationsDirectMessages?: boolean;
//   pushNotificationsITLUpdates?: boolean;
//   emailNotificationsAppReleases?: boolean;
//   emailNotificationsITLUpdates?: boolean;
// }) => {
//   if ((await usersRef.doc(data.id).get()).exists) {
//     return { id: data.id };
//   }

//   const filteredUsername = data.username?.trim().toLowerCase() || "anonymous";

//   usersRef.doc(data.id).set({
//     email: data.email || "",
//     username: filteredUsername,
//     bio: data.bio || "",
//     profilePicture: data.profilePicture || "",
//     location: data.location || "Global",
//     onboarded: data.onboarded || false,
//     loopsCount: data.loopsCount || 0,
//     badgesCount: data.badgesCount || 0,
//     deleted: false,
//     shadowBanned: data.shadowBanned || false,
//     accountType: data.accountType || "free",
//     twitterHandle: data.twitterHandle || "",
//     instagramHandle: data.instagramHandle || "",
//     tiktokHandle: data.tiktokHandle || "",
//     soundcloudHandle: data.soundcloudHandle || "",
//     youtubeChannelId: data.youtubeChannelId || "",
//     pushNotificationsLikes: data.pushNotificationsLikes || true,
//     pushNotificationsComments: data.pushNotificationsComments || true,
//     pushNotificationsFollows: data.pushNotificationsFollows || true,
//     pushNotificaionsDirectMessages:
//       data.pushNotificationsDirectMessages || true,
//     pushNotificationsITLUpdates: data.pushNotificationsITLUpdates || true,
//     emailNotificationsAppReleases: data.emailNotificationsAppReleases || true,
//     emailNotificationsITLUpdates: data.emailNotificationsITLUpdates || true,
//   });

//   return { id: data.id };
// };

const _deleteUser = async (data: { id: string }) => {
  // Checking attribute.
  if (data.id.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'id' cannot be empty"
    );
  }

  usersRef.doc(data.id).set({
    username: "*deleted*",
    deleted: true,
  });

  // *delete loop protocol*
  const userLoops = await loopsRef.where("userId", "==", data.id).get();
  userLoops.docs.forEach((snapshot) =>
    _deleteLoop({ id: snapshot.id, userId: data.id })
  );

  // *delete comment procotol*
  const userLoopsComments = await loopCommentsGroupRef
    .orderBy("timestamp", "desc")
    .where("userId", "==", data.id)
    .get();
  userLoopsComments.docs.forEach((snapshot) => {
    const comment = snapshot.data();
    _deleteComment({
      id: snapshot.id,
      rootId: comment.rootId,
      userId: comment.userId,
    });
  });

  // *delete all loops keyed at 'audio/loops/{UID}/{LOOPURL}'*
  storage
    .bucket("in-the-loop-306520.appspot.com")
    .deleteFiles({ prefix: `audio/loops/${data.id}` });

  // *delete all images keyed at 'images/users/{UID}/{IMAGEURL}'*
  storage
    .bucket("in-the-loop-306520.appspot.com")
    .deleteFiles({ prefix: `images/users/${data.id}` });

  // TODO: delete follower table stuff?
  // TODO: delete following table stuff?
  // TODO: delete stream info?
};

const _addActivity = async (data: {
  toUserId: string;
  fromUserId: string;
  type: string;
}) => {
  // Checking attribute.
  if (data.toUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'toUserId' cannot be empty"
    );
  }
  if (data.fromUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'fromUserId' cannot be empty"
    );
  }
  if (![ "follow", "like", "comment", "bookingRequest", "bookingUpdate", ].includes(data.type)) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'type' must be either " +
      "'follow', 'like', 'comment', 'bookingRequest', or 'bookingUpdate'"
    );
  }

  const docRef = await activitiesRef.add({
    toUserId: data.toUserId,
    fromUserId: data.fromUserId,
    timestamp: Timestamp.now(),
    type: data.type,
  });

  return { id: docRef.id };
};

const _deleteComment = async (data: {
  id: string;
  userId: string
  rootId: string,
}) => {
  // Checking attribute.
  if (data.id.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'id' cannot be empty"
    );
  }
  if (data.userId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'rootId' cannot be empty"
    );
  }
  if (data.rootId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'rootId' cannot be empty"
    );
  }

  const commentSnapshot = await commentsRef
    .doc(data.rootId)
    .collection("loopComments")
    .doc(data.id)
    .get();

  const rootId = commentSnapshot.data()?.["rootId"];
  loopsRef
    .doc(rootId)
    .update({ commentCount: FieldValue.increment(-1) });

  commentSnapshot.ref.update({
    content: "*deleted*",
    deleted: true,
  });
};

const _deleteLoop = async (data: { id: string; userId: string }) => {
  // Checking attribute.
  if (data.id.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'id' cannot be empty"
    );
  }

  const loopSnapshot = await loopsRef.doc(data.id).get();

  loopsRef.doc(data.id).update({
    audioPath: FieldValue.delete(),
    commentCount: FieldValue.delete(),
    downloads: FieldValue.delete(),
    likeCount: FieldValue.delete(),
    tags: FieldValue.delete(),
    timestamp: FieldValue.delete(),
    title: "*deleted*",
    deleted: true,
  });

  usersRef.doc(data.userId).update({
    loopsCount: FieldValue.increment(-1),
  });

  // *delete loops keyed at refFromURL(loop.audioPath)*
  if (loopSnapshot.data()?.audioPath != null) {
    storage
      .bucket("in-the-loop-306520.appspot.com")
      .file(_getFileFromURL(loopSnapshot.data()?.audioPath))
      .delete();
  }
};

const _copyUserLoopsToFeed = async (data: {
  loopsOwnerId: string;
  feedOwnerId: string;
}) => {
  const loopsQuerySnapshot = await loopsRef
    .where("userId", "==", data.loopsOwnerId)
    .limit(1000)
    .get();

  loopsQuerySnapshot.docs.forEach((doc) => {
    feedsRef
      .doc(data.feedOwnerId)
      .collection(loopsFeedSubcollection)
      .doc(doc.id)
      .set({
        timestamp: doc.data()["timestamp"] || Timestamp.now(),
        userId: data.loopsOwnerId,
      });
  });

  return data.feedOwnerId;
};

const _deleteUserLoopsFromFeed = (data: {
  loopsOwnerId: string;
  feedOwnerId: string;
}) => {
  feedsRef
    .doc(data.feedOwnerId)
    .collection(loopsFeedSubcollection)
    .where("userId", "==", data.loopsOwnerId)
    .limit(1000)
    .get()
    .then((query) => {
      query.docs.forEach((doc) => {
        doc.ref.delete();
      });
    });

  return data.feedOwnerId;
};

const _createStripeCustomer = async () => {
  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const customer = await stripe.customers.create();

  return customer.id;
}

const _createPaymentIntent = async (data: {
  destination?: string;
  amount?: number,
  customerId?: string,
}) => {


  if (data.destination === undefined || data.destination === null || data.destination === "") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'destination' cannot be empty"
    );
  }

  if (data.amount === undefined || data.amount === null || data.amount < 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'amount' cannot be empty or negative"
    );
  }

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });


  const customerId = (data.customerId === undefined || data.customerId === null || data.customerId === "")
    ? (await _createStripeCustomer())
    : data.customerId

  // Use an existing Customer ID if this is a returning customer.
  const ephemeralKey = await stripe.ephemeralKeys.create(
    { customer: customerId },
    { apiVersion: "2022-11-15" }
  );

  const remoteTemplate = await remote.getTemplate()
  const bookingFeeValue = remoteTemplate.parameters.booking_fee?.defaultValue;
  // const bookingFee = await getValue(remote, "booking_fee").asNumber();

  if (bookingFeeValue === undefined || bookingFeeValue === null) return;

  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  const weirdTSError = bookingFeeValue.value;

  const bookingFee = parseFloat(weirdTSError);

  // Set the application fee to be 10%
  const application_fee = data.amount * bookingFee;

  const paymentIntent = await stripe.paymentIntents.create({
    amount: Math.floor(data.amount),
    currency: "usd",
    customer: customerId,
    application_fee_amount: Math.floor(application_fee),
    automatic_payment_methods: {
      enabled: true,
    },
    transfer_data: {
      destination: data.destination,
    }
  });

  return {
    paymentIntent: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customerId,
    publishableKey: stripePublishableKey.value(),
  };
};

const _createStripeAccount = async () => {
  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const account = await stripe.accounts.create({
    type: "express",
    settings: {
      payouts: {
        schedule: {
          interval: "manual",
        },
      },
    },
  });

  return account.id;
}

const _createConnectedAccount = async (data: {
  accountId: string;
}) => {

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const accountId = (data.accountId === undefined || data.accountId === null || data.accountId === "")
    ? (await _createStripeAccount())
    : data.accountId

  const subdomain = "tappednetwork";
  const deepLink = "https://tappednetwork.page.link/connect_payment";
  const appInfo = "&apn=com.intheloopstudio&isi=1574937614&ibi=com.intheloopstudio";

  const refreshUrl = `https://${subdomain}.page.link/?link=${deepLink}?account_id=${accountId}&refresh=true${appInfo}`;
  const returnUrl = `https://${subdomain}.page.link/?link=${deepLink}?account_id=${accountId}`;

  const accountLinks = await stripe.accountLinks.create({
    account: accountId,
    refresh_url: refreshUrl,
    return_url: returnUrl,
    type: "account_onboarding",
  })

  return { success: true, url: accountLinks.url, accountId: accountId };
}

const _getAccountById = async (data: { accountId: string }) => {
  if (data.accountId === undefined || data.accountId === null || data.accountId === "") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'accountId' cannot be empty"
    );
  }

  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const account = await stripe.accounts.retrieve(data.accountId);

  return account;
}

// --------------------------------------------------------
export const sendToDevice = functions.firestore
  .document("activities/{activityId}")
  .onCreate(async (snapshot) => {
    const activity = snapshot.data();

    const userDoc = await usersRef.doc(activity["toUserId"]).get();
    const user = userDoc.data();
    if (user !== null) return;

    const activityType = activity["type"];

    let payload: messaging.MessagingPayload = {
      notification: {
        title: "New Activity",
        body: "You have new activity on your profile",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    switch (activityType) {
    case "comment":
      if (!user["pushNotificationsComments"]) return;

      payload = {
        notification: {
          title: "New Comment",
          body: "Someone commented on your loop 👀",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "like":
      if (!user["pushNotificationsLikes"]) return;
      payload = {
        notification: {
          title: "New Like",
          body: "Someone liked your loops 👍",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "follow":
      if (!user["pushNotificationsFollows"]) return;
      payload = {
        notification: {
          title: "New Follower",
          body: "You just got a new follower 🔥",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "bookingRequest":
      payload = {
        notification: {
          title: "New Booking Request",
          body: "You just got a new booking request 🔥",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "bookingUpdate":
      payload = {
        notification: {
          title: "Booking Update",
          body: "There was an update to one of your bookings",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    default:
      return;
    }

    const querySnapshot = await tokensRef
      .doc(activity["toUserId"])
      .collection("tokens")
      .get();

    const tokens: string[] = querySnapshot.docs.map((snap) => snap.id);
    if (tokens.length != 0) {
      return fcm.sendToDevice(tokens, payload);
    }

    return null;
  });
export const createStreamUserOnUserCreated = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .firestore
  .document("users/{userId}")
  .onCreate(async (snapshot) => {
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );

    const user = snapshot.data();
    await streamClient.upsertUser({
      id: user.id,
      name: user.artistName,
      username: user.username,
      email: user.email,
      image: user.profilePicture,
    });
  })

export const updateStreamUserOnUserUpdate = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .firestore
  .document("users/{userId}")
  .onUpdate(async (snapshot) => {
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );

    const user = snapshot.after.data();
    streamClient.partialUpdateUser({
      id: user.id,
      set: {
        name: user.artistName,
        username: user.username,
        email: user.email,
        image: user.profilePicture,
      },
    });
  })

export const addFollowersEntryOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onCreate(async (snapshot, context) => {
    await followersRef
      .doc(context.params.followeeId)
      .collection("Followers")
      .doc(context.params.followerId)
      .set({});
  });
export const copyLoopFeedOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onCreate(async (snapshot, context) => {
    _copyUserLoopsToFeed({
      loopsOwnerId: context.params.followeeId,
      feedOwnerId: context.params.followerId,
    });
  });

export const addActivityOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onCreate(async (snapshot, context) => {
    await _addActivity({
      toUserId: context.params.followeeId,
      fromUserId: context.params.followerId,
      type: "follow",
    });
  })

export const deleteUserLoopOnUnfollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    _deleteUserLoopsFromFeed({
      loopsOwnerId: context.params.followeeId,
      feedOwnerId: context.params.followerId,
    })
  });

export const deteteFollowersEntryOnUnfollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    const doc = await followersRef
      .doc(context.params.followeeId)
      .collection("Followers")
      .doc(context.params.followerId)
      .get();

    if (!doc.exists) {
      return;
    }

    doc.ref.delete()
  });


export const incrementLoopCountOnUpload = functions.firestore
  .document("loops/{loopId}")
  .onCreate(async (snapshot) => {
    const loop = snapshot.data();
    await usersRef
      .doc(loop.userId)
      .update({ loopsCount: FieldValue.increment(1) });
  })

export const sendLoopToFollowers = functions.firestore
  .document("loops/{loopId}")
  .onCreate(async (snapshot) => {
    const loop = snapshot.data();
    const userDoc = await usersRef.doc(loop.userId).get();
    // add loops to owner's feed
    await feedsRef
      .doc(loop.userId)
      .collection(loopsFeedSubcollection)
      .doc(snapshot.id)
      .set({
        timestamp: Timestamp.now(),
        userId: loop.userId,
      });

    const isShadowBanned: boolean = userDoc.data()?.["shadowBanned"] || false
    if (isShadowBanned === true) {
      return;
    }
    // get followers
    const followerSnapshot = await followersRef
      .doc(loop.userId)
      .collection("Followers")
      .get();

    // add loops to followers feed
    await Promise.all(
      followerSnapshot.docs.map(async (docSnapshot) => {
        return feedsRef
          .doc(docSnapshot.id)
          .collection(loopsFeedSubcollection)
          .doc(snapshot.id).set({
            timestamp: Timestamp.now(),
            userId: loop.userId,
          });
      }),
    );

  });

export const incrementLikeCountOnLoopLike = functions.firestore
  .document("likes/{loopId}/loopLikes/{userId}")
  .onCreate(async (snapshot, context) => {
    await loopsRef
      .doc(context.params.loopId)
      .update({ likeCount: FieldValue.increment(1) });
  });

export const addActivityOnLoopLike = functions.firestore
  .document("likes/{loopId}/loopLikes/{userId}")
  .onCreate(async (snapshot, context) => {
    const loopSnapshot = await loopsRef.doc(context.params.loopId).get();
    const loop = loopSnapshot.data();
    if (loop === undefined) {
      return;
    }

    if (loop.userId !== context.params.userId) {
      _addActivity({
        fromUserId: context.params.userId,
        type: "like",
        toUserId: loop.userId,
      });
    }
  });

export const decrementLoopLikeCountOnUnlike = functions.firestore
  .document("likes/{loopId}/loopLikes/{userId}")
  .onDelete(async (snapshot, context) => {
    await loopsRef
      .doc(context.params.loopId)
      .update({ likeCount: FieldValue.increment(-1) });
  })

export const addActivityOnBooking = functions.firestore
  .document("bookings/{bookingId}")
  .onCreate(async (snapshot, context) => {
    const booking = snapshot.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not exist`,);
    }

    _addActivity({
      fromUserId: booking.requesterId,
      type: "bookingRequest",
      toUserId: booking.requesteeId,
    });
  });
export const addActivityOnBookingUpdate = functions.firestore
  .document("bookings/{bookingId}")
  .onUpdate(async (change, context) => {
    const booking = change.after.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not exist`,);
    }

    Promise.all([
      _addActivity({
        fromUserId: booking.requesterId,
        type: "bookingRequest",
        toUserId: booking.requesteeId,
      }),
      _addActivity({
        fromUserId: booking.requesteeId,
        type: "bookingRequest",
        toUserId: booking.requesterId,
      }),
    ]);
  });

export const incrementLoopCommentCountOnComment = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const loopSnapshot = await loopsRef.doc(context.params.loopId).get();
    const loop = loopSnapshot.data();

    if (loop === undefined) {
      throw new HttpsError("failed-precondition", `loop ${context.params.loopId} does not exist`);
    }

    await loopsRef
      .doc(context.params.loopId)
      .update({ likeCount: FieldValue.increment(1) });
  });

export const addActivityOnLoopComment = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const comment = snapshot.data();
    const loopSnapshot = await loopsRef.doc(context.params.loopId).get();
    const loop = loopSnapshot.data();

    if (loop === undefined) {
      throw new HttpsError("failed-precondition", `loop ${context.params.loopId} does not exist`);
    }

    if (loop.userId !== comment.userId) {
      _addActivity({
        toUserId: loop.userId,
        fromUserId: comment.userId,
        type: "comment",
      });
    }
  });

export const incrementBadgeCountOnBadgeSent = functions.firestore
  .document("badgesSent/{userId}/badges/{badgeId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.userId)
      .update({ badgesCount: FieldValue.increment(1) });
  });

export const onUserDeleted = functions.auth
  .user()
  .onDelete((user: auth.UserRecord) => _deleteUser({ id: user.uid }));
export const deleteStreamUser = functions
  .runWith({ secrets: [ streamKey, streamSecret ] })
  .auth
  .user()
  .onDelete((user) => {
    const streamClient = StreamChat.getInstance(
      streamKey.value(),
      streamSecret.value(),
    );
    return streamClient.deleteUser(user.uid);
  });
export const addActivity = functions.https.onCall((data, context) => {
  _authenticated(context);
  return _addActivity(data);
});
export const createPaymentIntent = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    _authenticated(context);
    return _createPaymentIntent(data);
  });
export const createConnectedAccount = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    _authenticated(context);
    return _createConnectedAccount(data);
  })
export const getAccountById = functions
  .runWith({ secrets: [ stripeKey, stripePublishableKey ] })
  .https
  .onCall((data, context) => {
    _authenticated(context);
    return _getAccountById(data);
  });