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
import { Booking, Loop, Comment, FollowActivity, LikeActivity, CommentActivity, BookingRequestActivity, BookingUpdateActivity, CommentMentionActivity, LoopMentionActivity, BookingStatus, CommentLikeActivity, OpportunityInterest, } from "./models";

import { v4 as uuidv4 } from "uuid";

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
const followingRef = db.collection("following");
const followersRef = db.collection("followers");
// const likesRef = db.collection("likes");
const commentsRef = db.collection("comments");
const loopCommentsGroupRef = db.collectionGroup("loopComments");
const feedsRef = db.collection("feeds");
// const badgesRef = db.collection("badges");
// const badgesSentRef = db.collection("badgesSent");
const tokensRef = db.collection("device_tokens")
const servicesRef = db.collection("services");
const mailRef = db.collection("mail");
const queuedWritesRef = db.collection("queued_writes");

// const loopLikesSubcollection = "loopLikes";
// const loopCommentsSubcollection = "loopComments";
const loopsFeedSubcollection = "userFeed";

const bookingBotUuid = "90dc0775-3a0d-4e92-8573-9c7aa6832d94";

const founderIds = [
  "8yYVxpQ7cURSzNfBsaBGF7A7kkv2", // Johannes
  "n4zIL6bOuPTqRC3dtsl6gyEBPQl1", // Ilias
];


const _getFileFromURL = (fileURL: string): string => {
  const fSlashes = fileURL.split("/");
  const fQuery = fSlashes[fSlashes.length - 1].split("?");
  const segments = fQuery[0].split("%2F");
  const fileName = segments.join("/");

  return fileName;
};

const _getFoundersDeviceTokens = async () => {
  const deviceTokens = (
    await Promise.all(
      founderIds.map(
        async (founderId) => {

          const querySnapshot = await tokensRef
            .doc(founderId)
            .collection("tokens")
            .get();

          const tokens: string[] = querySnapshot.docs.map((snap) => snap.id);

          return tokens;
        })
    )
  ).flat();

  return deviceTokens;
}

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

const _addActivity = async (
  activity: FollowActivity
    | LikeActivity
    | CommentActivity
    | BookingRequestActivity
    | BookingUpdateActivity
    | LoopMentionActivity
    | CommentMentionActivity
    | CommentLikeActivity
    | OpportunityInterest
) => {
  // Checking attribute.A
  if (activity.toUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'toUserId' cannot be empty"
    );
  }
  if (activity.fromUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'fromUserId' cannot be empty"
    );
  }
  if (![
    "follow",
    "like",
    "comment",
    "bookingRequest",
    "bookingUpdate",
    "loopMention",
    "commentMention",
    "commentLike",
    "opportunityInterest"
  ].includes(activity.type)) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'type' must be either " +
      "'follow', 'like', 'comment', 'bookingRequest', 'bookingUpdate', 'loopMention', or 'commentMention'"
    );
  }

  const docRef = await activitiesRef.add({
    ...activity,
    timestamp: Timestamp.now(),
    markedRead: false,
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

const _createStripeCustomer = async (email?: string) => {
  const stripe = new Stripe(stripeKey.value(), {
    apiVersion: "2022-11-15",
  });

  const customer = await stripe.customers.create({ email: email });

  return customer.id;
}

const _createPaymentIntent = async (data: {
  destination?: string;
  amount?: number,
  customerId?: string,
  receiptEmail?: string,
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
    ? (await _createStripeCustomer(data.receiptEmail))
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
    },
    receipt_email: data.receiptEmail,
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
    // cross border payments only work with
    // recipient accounts
    // tos_acceptance: {
    //   service_agreement: "recipient",
    // },
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

const _sendWelcomeEmail = async (toEmail: string) => {
  await mailRef.add({
    to: [ toEmail ],
    template: {
      name: "welcome",
    },
  })
}

const _sendBookingRequestReceivedEmail = async (toEmail: string) => {
  await mailRef.add({
    to: [ toEmail ],
    template: {
      name: "bookingRequestReceived",
    },
  })
}

const _sendBookingRequestSentEmail = async (toEmail: string) => {
  await mailRef.add({
    to: [ toEmail ],
    template: {
      name: "bookingRequestSent",
    },
  })
}

// --------------------------------------------------------
export const sendToDevice = functions.firestore
  .document("activities/{activityId}")
  .onCreate(async (snapshot) => {
    const activity = snapshot.data();

    const userDoc = await usersRef.doc(activity["toUserId"]).get();
    const user = userDoc.data();
    if (user === null || user === undefined) {
      throw new Error("User not found");
    }

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
    case "loopMention":
      payload = {
        notification: {
          title: "Mention",
          body: "Someone mentioned you in a loop",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      break;
    case "commentMention":
      payload = {
        notification: {
          title: "Mention",
          body: "Someone mentioned you in a comment",
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
    if (tokens.length == 0) {
      functions.logger.debug("No tokens to send to");
    }

    try {
      const resp = await fcm.sendToDevice(tokens, payload);
      if (resp.failureCount > 0) {
        functions.logger.warn(`Failed to send message to some devices: ${resp.failureCount}`);
      }
    } catch (e: any) {
      functions.logger.error(`${user["id"]} : ${e}`);
      throw new Error(`cannot send notification to device, userId: ${user["id"]}, ${e.message}`);
    }
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
export const autoFollowUsersOnUserCreated = functions
  .firestore
  .document("users/{userId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const userIdsToAutoFollow = [
      "8yYVxpQ7cURSzNfBsaBGF7A7kkv2", // Johannes
      "n4zIL6bOuPTqRC3dtsl6gyEBPQl1", // Ilias
      "ToPGEF6jP1e7R6XJDsOHYSyBpf22", // Amberay
      "aDsHZs9v2BcUWJZYIRAPbX6KSMs2", // Phil
      "7wEC1jNzsShn3wd8BWXC0w89aIF3" // Xypper
      // "kNVsCCnDkFdYAxebMspLpnEudwq1", // Jayduhhhh
      // "xfxTCUerCyZCUB85likg7THcUGD2", // Yung Smilez
      // "EczWgsPTL1ROJ6EU93Q5vs0Osfx2", // Akimi
    ];

    functions.logger.debug(`auto following users for ${userId}`)

    for (const userIdToAutoFollow of userIdsToAutoFollow) {
      await followingRef
        .doc(userId)
        .collection("Following")
        .doc(userIdToAutoFollow)
        .set({});
    }
  })
export const sendWelcomeEmailOnUserCreated = functions
  .firestore
  .document("users/{usersId}")
  .onCreate(async (snapshot) => {
    const user = snapshot.data();
    const email = user.email;

    if (email === undefined || email === null || email === "") {
      throw new Error("user email is undefined, null or empty: " + JSON.stringify(user));
    }

    functions.logger.debug(`sending welcome email to ${email}`);

    await _sendWelcomeEmail(email);
  });
export const notifyFoundersOnFirstOpen = functions
  .analytics
  .event("first_open")
  .onLog(async (event) => {
    const devices = await _getFoundersDeviceTokens();
    const user = event.user;
    const payload = {
      notification: {
        title: "You have a new user \uD83D\uDE43",
        body: `${user?.deviceInfo.mobileModelName} from ${user?.geoInfo.city}, ${user?.geoInfo.country}`,
      }
    };

    fcm.sendToDevice(devices, payload);
  });
export const notifyFoundersOnAppRemoved = functions
  .analytics
  .event("app_remove")
  .onLog(async (event) => {
    const devices = await _getFoundersDeviceTokens();
    const user = event.user;
    const payload = {
      notification: {
        title: "You lost a user \uD83D\uDE1E",
        body: `${user?.deviceInfo.mobileModelName} from ${user?.geoInfo.city}, ${user?.geoInfo.country}`,
      }
    };

    fcm.sendToDevice(devices, payload);
  });

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
export const decrementFollowersCountOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onDelete(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followeeId)
      .update({
        followerCount: FieldValue.increment(-1),
      });
  });
export const decrementFollowingCountOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onDelete(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followerId)
      .update({
        followingCount: FieldValue.increment(-1),
      });
  });
export const incrementFollowersCountOnFollow = functions.firestore
  .document("following/{followerId}/Following/{followeeId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followeeId)
      .update({
        followerCount: FieldValue.increment(1),
      });
  });
export const incrementFollowingCountOnFollow = functions.firestore
  .document("followers/{followeeId}/Followers/{followerId}")
  .onCreate(async (snapshot, context) => {
    await usersRef
      .doc(context.params.followerId)
      .update({
        followingCount: FieldValue.increment(1),
      });
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
export const notifyMentionsOnLoopUpload = functions.firestore
  .document("loops/{loopId}")
  .onCreate(async (snapshot) => {
    const loop = snapshot.data() as Loop;
    const description = loop.description;
    const userTagRegex = /^(.*?)(?<![\w@])@([\w@]+(?:[.!][\w@]+)*)/;

    description.match(userTagRegex)?.forEach(async (match: string) => {
      const username = match.replace("@", "");
      const userDoc = await usersRef.where("username", "==", username).get();
      if (userDoc.empty) {
        functions.logger.error(`user ${username} not found`)
        return;
      }

      const user = userDoc.docs[0].data();

      functions.logger.info(`new mention ${user.id} by ${loop.userId}`)
      await _addActivity({
        toUserId: user.id,
        fromUserId: loop.userId,
        type: "loopMention",
        loopId: loop.id,
      });
    });
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
        loopId: context.params.loopId,
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

export const incrementLikeCountOnCommentLike = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}/commentLikes/{userId}")
  .onCreate(async (snapshot, context) => {
    await commentsRef
      .doc(context.params.loopId)
      .collection("loopComments")
      .doc(context.params.commentId)
      .update({ likeCount: FieldValue.increment(1) });
  });
export const decrementLoopLikeCountOnCommentUnlike = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}/commentLikes/{userId}")
  .onDelete(async (snapshot, context) => {
    await commentsRef
      .doc(context.params.loopId)
      .collection("loopComments")
      .doc(context.params.commentId)
      .update({ likeCount: FieldValue.increment(-1) });
  });
export const addActivityOnCommentLike = functions.firestore
  .document("comments/{rootId}/loopComments/{commentId}/commentLikes/{userId}")
  .onCreate(async (snapshot, context) => {
    const commentSnapshot = await commentsRef
      .doc(context.params.rootId)
      .collection("loopComments")
      .doc(context.params.commentId)
      .get();

    const comment = commentSnapshot.data();
    if (comment === undefined) {
      return;
    }

    if (comment.userId !== context.params.userId) {
      _addActivity({
        toUserId: comment.userId,
        fromUserId: context.params.userId,
        type: "commentLike",
        commentId: context.params.commentId,
        rootId: context.params.rootId,
      });
    }
  });

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
      bookingId: context.params.bookingId,
    });
  });
export const addActivityOnBookingUpdate = functions.firestore
  .document("bookings/{bookingId}")
  .onUpdate(async (change, context) => {
    const booking = change.after.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not exist`,);
    }

    const status = booking.status as BookingStatus;

    const uid = context.auth?.uid;

    if (uid === undefined || uid === null) {
      throw new HttpsError("unauthenticated", "user is not authenticated");
    }

    for (const userId of [ booking.requesterId, booking.requesteeId ]) {
      if (userId === uid) {
        continue;
      }
      await _addActivity({
        fromUserId: uid,
        type: "bookingUpdate",
        toUserId: userId,
        bookingId: context.params.bookingId,
        status: status,
      });
    }
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
      .update({ commentCount: FieldValue.increment(1) });
  });
export const notifyMentionsOnComment = functions.firestore
  .document("comments/{loopId}/loopComments/{commentId}")
  .onCreate(async (snapshot, context) => {
    const comment = snapshot.data() as Comment;

    const text = comment.content;
    const userTagRegex = /^(.*?)(?<![\w@])@([\w@]+(?:[.!][\w@]+)*)/;

    text.match(userTagRegex)?.forEach(async (match: string) => {
      const username = match.replace("@", "");
      const userDoc = await usersRef.where("username", "==", username).get();
      if (userDoc.empty) {
        return;
      }

      const user = userDoc.docs[0].data();

      functions.logger.info(`new mention ${user.id} by ${comment.userId}`)
      await _addActivity({
        toUserId: user.id,
        fromUserId: comment.userId,
        type: "commentMention",
        rootId: context.params.loopId,
        commentId: context.params.commentId,
      });
    });
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
        rootId: context.params.loopId,
        commentId: context.params.commentId,
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

export const incrementServiceCountOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (snapshot, context) => {
    const booking = snapshot.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not exist`,);
    }

    if (booking.serviceId === undefined) {
      throw new HttpsError("failed-precondition", `booking ${context.params.bookingId} does not have a serviceId`,);
    }

    await servicesRef
      .doc(booking.serviceId)
      .update({ bookingCount: FieldValue.increment(1) });
  });

export const transformLoopPayloadForSearch = functions.https
  .onCall((data) => {

    const { lat, lng, ...rest } = data;

    const payload: Record<string, any> = rest;

    if (lat !== undefined && lat !== null && lng !== undefined && lng !== null) {
      payload._geoloc = { lat, lng }
    }

    return payload;
  })
export const notifyFoundersOnBookings = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (data) => {
    const booking = data.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${data.id} does not exist`,);
    }

    if (booking.serviceId === undefined) {
      throw new HttpsError("failed-precondition", `booking ${data.id} does not have a serviceId`,);
    }

    const serviceSnapshot = await servicesRef
      .doc(booking.requesteeId)
      .collection("userServices")
      .doc(booking.serviceId)
      .get();

    const service = serviceSnapshot.data();

    const requesterSnapshot = await usersRef.doc(booking.requesterId).get();
    const requester = requesterSnapshot.data();

    const requesteeSnapshot = await usersRef.doc(booking.requesteeId).get();
    const requestee = requesteeSnapshot.data();

    const payload: messaging.MessagingPayload = {
      notification: {
        title: "NEW TAPPED BOOKING!!!",
        body: `${requester?.artistName ?? "<UNKNOWN>"} booked ${requestee?.artistName ?? "<UNKNOWN>"} for service ${service?.title ?? "<UNKNOWN>"}`,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    const deviceTokens = await _getFoundersDeviceTokens();

    try {
      const resp = await fcm.sendToDevice(deviceTokens, payload);
      if (resp.failureCount > 0) {
        functions.logger.warn(`Failed to send message to some devices: ${resp.failureCount}`);
      }
    } catch (e: any) {
      functions.logger.error(`ERROR : ${e}`);
      throw new Error(`cannot send notification to device ${e.message}`);
    }
  });
export const postFromBookingBotOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (data) => {
    const booking = data.data() as Booking;
    if (booking === undefined) {
      throw new HttpsError("failed-precondition", `booking ${data.id} does not exist`,);
    }

    if (booking.serviceId === undefined) {
      throw new HttpsError("failed-precondition", `booking ${data.id} does not have a serviceId`,);
    }

    const serviceSnapshot = await servicesRef
      .doc(booking.requesteeId)
      .collection("userServices")
      .doc(booking.serviceId)
      .get();

    const service = serviceSnapshot.data();

    const requesterSnapshot = await usersRef.doc(booking.requesterId).get();
    const requester = requesterSnapshot.data();

    const requesteeSnapshot = await usersRef.doc(booking.requesteeId).get();
    const requestee = requesteeSnapshot.data();

    const uuid = uuidv4();
    const post = {
      id: uuid,
      userId: bookingBotUuid,
      title: "🎫 NEW BOOKING",
      description: `@${requester?.username ?? "UNNKOWN"} booked @${requestee?.username ?? "UNKNOWN"} for service '${service?.title ?? "UNKNOWN"}'`,
      imagePaths: [],
      timestamp: Timestamp.now(),
      likeCount: 0,
      commentCount: 0,
      shareCount: 0,
      deleted: false,
    }
    await loopsRef.doc(uuid).set(post);
  });

export const sendBookingRequestReceivedEmailOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (data) => {
    const booking = data.data() as Booking;
    const requesteeSnapshot = await usersRef.doc(booking.requesteeId).get();
    const requestee = requesteeSnapshot.data();
    const email = requestee?.email;

    if (email === undefined || email === null || email === "") {
      throw new Error(`requestee ${requestee?.id} does not have an email`);
    }

    await _sendBookingRequestReceivedEmail(email);
  });
export const sendBookingRequestSentEmailOnBooking = functions
  .firestore
  .document("bookings/{bookingId}")
  .onCreate(async (data) => {
    const booking = data.data() as Booking;
    const requesterSnapshot = await usersRef.doc(booking.requesterId).get();
    const requester = requesterSnapshot.data();
    const email = requester?.email;

    if (email === undefined || email === null || email === "") {
      throw new Error(`requester ${requester?.id} does not have an email`);
    }

    await _sendBookingRequestSentEmail(email);
  });
export const sendBookingNotificationsOnBookingConfirmed = functions
  .firestore
  .document("bookings/{bookingId}")
  .onUpdate(async (data) => {
    const booking = data.after.data() as Booking;
    const bookingBefore = data.before.data() as Booking;

    if (booking.status !== "confirmed" || bookingBefore.status === "confirmed") {
      functions.logger.info(`booking ${booking.id} is not confirmed or was already confirmed`);
      return;
    }

    const requesteeSnapshot = await usersRef.doc(booking.requesteeId).get();
    const requestee = requesteeSnapshot.data();
    const requesteeEmail = requestee?.email;

    if (requesteeEmail === undefined || requesteeEmail === null || requesteeEmail === "") {
      throw new Error(`requestee ${requestee?.id} does not have an email`);
    }

    const requesterSnapshot = await usersRef.doc(booking.requesterId).get();
    const requester = requesterSnapshot.data();
    const requesterEmail = requester?.email;

    if (requesterEmail === undefined || requesterEmail === null || requesterEmail === "") {
      throw new Error(`requester ${requester?.id} does not have an email`);
    }


    const ONE_HOUR_MS = 60 * 60 * 1000;
    const ONE_DAY_MS = 24 * ONE_HOUR_MS;
    const ONE_WEEK_MS = 7 * ONE_DAY_MS;
    const reminders = [
      {
        userId: booking.requesteeId,
        email: requesteeEmail,
        offset: ONE_HOUR_MS,
        type: "bookingReminderRequestee",
      },
      {
        userId: booking.requesteeId,
        email: requesteeEmail,
        offset: ONE_DAY_MS,
        type: "bookingReminderRequestee",
      },
      {
        userId: booking.requesteeId,
        email: requesteeEmail,
        offset: ONE_WEEK_MS,
        type: "bookingReminderRequestee",
      },
      {
        userId: booking.requesterId,
        email: requesterEmail,
        offset: ONE_HOUR_MS,
        type: "bookingReminderRequester",
      },
      {
        userId: booking.requesterId,
        email: requesterEmail,
        offset: ONE_DAY_MS,
        type: "bookingReminderRequester",
      },
      {
        userId: booking.requesterId,
        email: requesterEmail,
        offset: ONE_WEEK_MS,
        type: "bookingReminderRequester",
      },
    ]

    const startTime = booking.startTime.toDate().getTime();

    // Create schedule write for push notification
    // 1 week, 1 day, and 1 hour before booking start time
    for (const reminder of reminders) {

      if ((startTime - reminder.offset) < Date.now()) {
        functions.logger.info("too late to send reminder, skipping reminder");
        continue;
      }

      await Promise.all([
        queuedWritesRef.add({
          state: "PENDING",
          data: {
            toUserId: reminder.userId,
            fromUserId: "8yYVxpQ7cURSzNfBsaBGF7A7kkv2", // Johannes
            type: "bookingReminder",
            bookingId: booking.id,
            timestamp: Timestamp.now(),
            markedRead: false,
          },
          collection: "activities",
          deliverTime: Timestamp.fromMillis(
            startTime - reminder.offset,
          ),
        }),
        // queuedWritesRef.add({
        //   state: "PENDING",
        //   data: {
        //     to: [ reminder.email ],
        //     template: {
        //       // e.g. bookingReminderRequestee-3600000
        //       name: `${reminder.type}-${reminder.offset}`,
        //     },
        //   },
        //   collection: "mail",
        //   deliverTime: Timestamp.fromMillis(
        //     startTime - reminder.offset,
        //   ),
        // }),
      ]);
    }
  });

export const addActivityOnOpportunityInterest = functions
  .firestore
  .document("opportunities/{loopId}/interestedUsers/{userId}")
  .onCreate(async (data, context) => {
    const loopSnapshot = await loopsRef.doc(context.params.loopId).get();
    const loop = loopSnapshot.data() as Loop;

    _addActivity({
      toUserId: loop.userId,
      fromUserId: context.params.userId,
      type: "opportunityInterest",
      loopId: context.params.loopId,
    });
  });
