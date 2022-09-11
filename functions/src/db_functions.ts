import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {firestore} from "firebase-admin";

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
const storage = admin.storage();
const fcm = admin.messaging();

const usersRef = db.collection("users");
const loopsRef = db.collection("loops");
const activitiesRef = db.collection("activities");
const followingRef = db.collection("following");
const followersRef = db.collection("followers");
const likesRef = db.collection("likes");
const commentsRef = db.collection("comments");
const commentsGroupRef = db.collectionGroup("loopComments");
const feedsRef = db.collection("feeds");
const badgesRef = db.collection("badges");

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

const _authorized = (
  context: functions.https.CallableContext,
  userId: string
) => {
  // Checking that the user is authenticated.
  if (context.auth!.uid !== userId) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "failed-precondition",
      "No authorized to call this function with the specified parameters"
    );
  }
};

export const sendToDevice = functions.firestore
  .document("activities/{activityId}")
  .onCreate(async (snapshot) => {
    const activity = snapshot.data();

    const userDoc = await usersRef.doc(activity["toUserId"]).get();
    const user = userDoc.data();
    if (user !== null) return;

    const activityType = activity["type"];

    let payload: admin.messaging.MessagingPayload = {
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
    default:
      return;
    }

    const querySnapshot = await usersRef
      .doc(activity["toUserId"])
      .collection("tokens")
      .get();

    const tokens: string[] = querySnapshot.docs.map((snap) => snap.id);
    if (tokens.length != 0) {
      return fcm.sendToDevice(tokens, payload);
    }

    return null;
  });

const _createUser = async (data: {
  id: string;
  email?: string | undefined;
  username?: string | undefined;
  bio?: string | undefined;
  profilePicture?: string | undefined;
  location?: string | undefined;
  onboarded?: boolean | undefined;
  loopsCount?: number | undefined;
  badgesCount?: number | undefined;
  shadowBanned?: boolean | undefined;
  accountType?: string | undefined;
  twitterHandle?: string | undefined;
  instagramHandle?: string | undefined;
  tiktokHandle?: string | undefined;
  soundcloudHandle?: string | undefined;
  youtubeChannelId?: string | undefined;
  pushNotificationsLikes?: boolean;
  pushNotificationsComments?: boolean;
  pushNotificationsFollows?: boolean;
  pushNotificationsDirectMessages?: boolean;
  pushNotificationsITLUpdates?: boolean;
  emailNotificationsAppReleases?: boolean;
  emailNotificationsITLUpdates?: boolean;
}) => {
  console.log(data);

  if ((await usersRef.doc(data.id).get()).exists) {
    return {id: data.id};
  }

  const filteredUsername = data.username?.trim().toLowerCase() || "anonymous";

  usersRef.doc(data.id).set({
    email: data.email || "",
    username: filteredUsername,
    bio: data.bio || "",
    profilePicture: data.profilePicture || "",
    location: data.location || "Global",
    onboarded: data.onboarded || false,
    loopsCount: data.loopsCount || 0,
    badgesCount: data.badgesCount || 0,
    deleted: false,
    shadowBanned: data.shadowBanned || false,
    accountType: data.accountType || "free",
    twitterHandle: data.twitterHandle || "",
    instagramHandle: data.instagramHandle || "",
    tiktokHandle: data.tiktokHandle || "",
    soundcloudHandle: data.soundcloudHandle || "",
    youtubeChannelId: data.youtubeChannelId || "",
    pushNotificationsLikes:
      data.pushNotificationsLikes || true,
    pushNotificationsComments:
      data.pushNotificationsComments || true,
    pushNotificationsFollows:
      data.pushNotificationsFollows || true,
    pushNotificaionsDirectMessages:
      data.pushNotificationsDirectMessages || true,
    pushNotificationsITLUpdates:
      data.pushNotificationsITLUpdates || true,
    emailNotificationsAppReleases:
      data.emailNotificationsAppReleases || true,
    emailNotificationsITLUpdates:
      data.emailNotificationsITLUpdates || true,
  });

  return {id: data.id};
};

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
    _deleteLoop({id: snapshot.id, userId: data.id})
  );

  // *delete comment procotol*
  const userComments = await commentsGroupRef
    .orderBy("timestamp", "desc")
    .where("userId", "==", data.id)
    .get();
  userComments.docs.forEach((snapshot) => {
    const comment = snapshot.data();
    _deleteComment({
      id: snapshot.id,
      loopId: comment.rootLoopId,
      userId: comment.userId,
    });
  });

  // *delete all loops keyed at 'audio/loops/{UID}/{LOOPURL}'*
  storage
    .bucket("in-the-loop-306520.appspot.com")
    .deleteFiles({prefix: `audio/loops/${data.id}`});

  // *delete all images keyed at 'images/users/{UID}/{IMAGEURL}'*
  storage
    .bucket("in-the-loop-306520.appspot.com")
    .deleteFiles({prefix: `images/users/${data.id}`});

  // TODO: delete follower table stuff?
  // TODO: delete following table stuff?
  // TODO: delete stream info?
};

const _updateUserData = async (data: {
  id: string;
  email?: string;
  username?: string;
  bio?: string;
  profilePicture?: string;
  location?: string;
  onboarded?: boolean;
  loopsCount?: number;
  badgesCount?: number;
  deleted?: boolean;
  shadowBanned?: boolean;
  accountType?: string;
  twitterHandle?: string;
  instagramHandle?: string;
  tiktokHandle?: string;
  soundcloudHandle?: string;
  youtubeChannelId?: string;
  pushNotificationsLikes?: boolean;
  pushNotificationsComments?: boolean;
  pushNotificationsFollows?: boolean;
  pushNotificationsDirectMessages?: boolean;
  pushNotificationsITLUpdates?: boolean;
  emailNotificationsAppReleases?: boolean;
  emailNotificationsITLUpdates?: boolean;
}) => {
  // Checking attribute.
  if (data.username?.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'username' cannot be empty"
    );
  }
  if (data.email?.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'email' cannot be empty"
    );
  }
  if ((data.loopsCount || 0) < 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopsCount' cannot be negative"
    );
  }

  const filteredUsername = data.username?.trim().toLowerCase() || "anonymous";
  if (
    filteredUsername !== null &&
    filteredUsername !== undefined &&
    !_checkUsernameAvailability({username: filteredUsername, userId: data.id})
  ) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'username' cannot already be in use"
    );
  }


  usersRef.doc(data.id).update({
    email: data.email || "",
    username: filteredUsername,
    bio: data.bio || "",
    profilePicture: data.profilePicture || "",
    location: data.location || "Global",
    onboarded: data.onboarded || false,
    loopsCount: data.loopsCount || 0,
    badgesCount: data.badgesCount || 0,
    deleted: data.deleted || false,
    shadowBanned: data.shadowBanned || false,
    accountType: data.accountType || "free",
    twitterHandle: data.twitterHandle || "",
    instagramHandle: data.instagramHandle || "",
    tiktokHandle: data.tiktokHandle || "",
    soundcloudHandle: data.soundcloudHandle || "",
    youtubeChannelId: data.youtubeChannelId || "",
    pushNotificationsLikes:
      data.pushNotificationsLikes || true,
    pushNotificationsComments:
      data.pushNotificationsComments || true,
    pushNotificationsFollows:
      data.pushNotificationsFollows || true,
    pushNotificaionsDirectMessages:
      data.pushNotificationsDirectMessages || true,
    pushNotificationsITLUpdates:
      data.pushNotificationsITLUpdates || true,
    emailNotificationsAppReleases:
      data.emailNotificationsAppReleases || true,
    emailNotificationsITLUpdates:
      data.emailNotificationsITLUpdates || true,
  });

  return {id: data.id};
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
  if (!["follow", "like", "comment"].includes(data.type)) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'type' must be either " +
      "'follow', 'like', or 'comment'"
    );
  }

  const docRef = await activitiesRef.add({
    toUserId: data.toUserId,
    fromUserId: data.fromUserId,
    timestamp: admin.firestore.Timestamp.now(),
    type: data.type,
  });

  return {id: docRef.id};
};

const _markActivityAsRead = async (data: { id: string }) => {
  if (data.id.length === 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'id' cannot be empty"
    );
  }

  activitiesRef.doc(data.id).update({
    markedRead: true,
  });

  return data.id;
};

const _followUser = async (data: { follower: string; followed: string }) => {
  // Checking attribute.
  if (data.follower.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'follower' cannot be empty"
    );
  }
  if (data.followed.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'followed' cannot be empty"
    );
  }
  followingRef
    .doc(data.follower)
    .collection("Following")
    .doc(data.followed)
    .get()
    .then(async (doc) => {
      if (!doc.exists) {
        await followingRef
          .doc(data.follower)
          .collection("Following")
          .doc(data.followed)
          .set({});
        await followersRef
          .doc(data.followed)
          .collection("Followers")
          .doc(data.follower)
          .set({});

        _addActivity({
          toUserId: data.followed,
          fromUserId: data.follower,
          type: "follow",
        });

        _copyUserLoopsToFeed({
          loopsOwnerId: data.followed,
          feedOwnerId: data.follower,
        });
      }
    });
  return data;
};

const _unfollowUser = async (data: { follower: string; followed: string }) => {
  // Checking attribute.
  if (data.follower.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'follower' cannot be empty"
    );
  }
  if (data.followed.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'followed' cannot be empty"
    );
  }

  followingRef
    .doc(data.follower)
    .collection("Following")
    .doc(data.followed)
    .get()
    .then((doc) => {
      if (doc.exists) {
        doc.ref.delete();

        _deleteUserLoopsFromFeed({
          loopsOwnerId: data.followed,
          feedOwnerId: data.follower,
        });
      }
    });

  followersRef
    .doc(data.followed)
    .collection("Followers")
    .doc(data.follower)
    .get()
    .then((doc) => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });

  return data;
};

const _likeLoop = async (data: {
  currentUserId: string;
  loopId: string;
  loopUserId: string;
}) => {
  // Checking attribute.
  if (data.currentUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'currentUserId' cannot be empty"
    );
  }
  if (data.loopId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopId' cannot be empty"
    );
  }
  if (data.loopUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopUserId' cannot be empty"
    );
  }

  likesRef
    .doc(data.loopId)
    .collection("loopLikes")
    .doc(data.currentUserId)
    .get()
    .then((doc) => {
      if (!doc.exists) {
        doc.ref.set({});

        loopsRef
          .doc(data.loopId)
          .update({likes: admin.firestore.FieldValue.increment(1)});

        if (data.currentUserId != data.loopUserId) {
          _addActivity({
            fromUserId: data.currentUserId,
            type: "like",
            toUserId: data.loopUserId,
          });
        }
      }
    });

  return {loopId: data.loopId};
};

const _unlikeLoop = async (data: { currentUserId: string; loopId: string }) => {
  // Checking attribute.
  if (data.currentUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'currentUserId' cannot be empty"
    );
  }
  if (data.loopId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopId' cannot be empty"
    );
  }

  likesRef
    .doc(data.loopId)
    .collection("loopLikes")
    .doc(data.currentUserId)
    .get()
    .then((doc) => {
      if (doc.exists) {
        doc.ref.delete();

        loopsRef
          .doc(data.loopId)
          .update({likes: admin.firestore.FieldValue.increment(-1)});
      }
    });
};

const _addComment = async (data: {
  visitedUserId: string;
  rootLoopId: string;
  userId: string;
  content: string;
  parentId: string | null;
  children: Array<string>;
}) => {
  // Checking attribute.
  if (data.visitedUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'visitedUserId' cannot be empty"
    );
  }
  if (data.rootLoopId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'rootLoopId' cannot be empty"
    );
  }
  if (data.userId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'userId' cannot be empty"
    );
  }
  if (data.content.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'content' cannot be empty"
    );
  }

  commentsRef.doc(data.rootLoopId).collection("loopComments").add({
    userId: data.userId,
    timestamp: admin.firestore.Timestamp.now(),
    content: data.content,
    parentId: data.parentId,
    rootLoopId: data.rootLoopId,
    children: data.children,
    deleted: false,
  });

  loopsRef
    .doc(data.rootLoopId)
    .update({comments: admin.firestore.FieldValue.increment(1)});

  if (data.visitedUserId != data.userId) {
    _addActivity({
      toUserId: data.visitedUserId,
      fromUserId: data.userId,
      type: "comment",
    });
  }
};

const _deleteComment = async (data: {
  id: string;
  loopId: string;
  userId: string;
}) => {
  // Checking attribute.
  if (data.id.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'id' cannot be empty"
    );
  }
  if (data.loopId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopId' cannot be empty"
    );
  }
  if (data.userId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'userId' cannot be empty"
    );
  }

  const commentSnapshot = await commentsRef
    .doc(data.loopId)
    .collection("loopComments")
    .doc(data.id)
    .get();

  const rootLoopId = commentSnapshot.data()?.["rootLoopId"];
  loopsRef
    .doc(rootLoopId)
    .update({comments: admin.firestore.FieldValue.increment(-1)});

  commentSnapshot.ref.update({
    content: "*deleted*",
    deleted: true,
  });
};

const _uploadLoop = async (data: {
  loopUserId: string;
  loopTitle: string;
  loopAudio: string;
  loopLikes: number;
  loopDownloads: number;
  loopComments: number;
  loopTags: Array<string>;
}) => {
  // Checking attribute.
  if (data.loopUserId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopUserId' cannot be empty"
    );
  }
  if (data.loopTitle.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopTitle' cannot be empty"
    );
  }
  if (data.loopAudio.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopAudio' cannot be empty"
    );
  }
  if (data.loopLikes < 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'loopLikes' cannot be negative"
    );
  }
  if (data.loopDownloads < 0) {
    // throwing an httpserror so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "the function argument 'loopDownloads' cannot be negative"
    );
  }
  if (data.loopComments < 0) {
    // throwing an httpserror so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "the function argument 'loopComments' cannot be negative"
    );
  }

  usersRef
    .doc(data.loopUserId)
    .update({loopsCount: admin.firestore.FieldValue.increment(1)});

  loopsRef
    .add({
      title: data.loopTitle,
      audio: data.loopAudio,
      userId: data.loopUserId,
      timestamp: admin.firestore.Timestamp.now(),
      likes: data.loopLikes,
      downloads: data.loopDownloads,
      comments: data.loopComments,
      tags: data.loopTags,
      deleted: false,
    })
    .then(async (doc) => {
      const userDoc = await usersRef.doc(data.loopUserId).get();
      if (
        userDoc.data()!["shadowBanned"] == null ||
        userDoc.data()!["shadowBanned"] != true
      ) {
        // get followers
        const followerSnapshot = await followersRef
          .doc(data.loopUserId)
          .collection("Followers")
          .get();

        // add loops to followers feed
        followerSnapshot.docs.forEach((docSnapshot) => {
          feedsRef.doc(docSnapshot.id).collection("userFeed").doc(doc.id).set({
            timestamp: admin.firestore.Timestamp.now(),
            userId: data.loopUserId,
          });
        });
      }

      // add loops to owner's feed
      feedsRef.doc(data.loopUserId).collection("userFeed").doc(doc.id).set({
        timestamp: admin.firestore.Timestamp.now(),
        userId: data.loopUserId,
      });
    });

  // return { id: doc.id };
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
    audio: firestore.FieldValue.delete(),
    comments: firestore.FieldValue.delete(),
    downloads: firestore.FieldValue.delete(),
    likes: firestore.FieldValue.delete(),
    tags: firestore.FieldValue.delete(),
    timestamp: firestore.FieldValue.delete(),
    title: "*deleted*",
    deleted: true,
  });

  usersRef.doc(data.userId).update({
    loopsCount: admin.firestore.FieldValue.increment(-1),
  });

  // *delete loops keyed at refFromURL(loop.audio)*
  if (loopSnapshot.data()?.audio != null) {
    storage
      .bucket("in-the-loop-306520.appspot.com")
      .file(_getFileFromURL(loopSnapshot.data()?.audio))
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
      .collection("userFeed")
      .doc(doc.id)
      .set({
        timestamp: doc.data()["timestamp"] || admin.firestore.Timestamp.now(),
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
    .collection("userFeed")
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

const _shareLoop = (data: {
  loopId: string,
  userId: string,
}) => {
  const results = loopsRef.doc(data.loopId).update({
    shares: admin.firestore.FieldValue.increment(1),
  });

  return results;
};

const _checkUsernameAvailability = async (data: {
  userId: string,
  username: string,
}) => {
  const blacklist = [
    "anonymous",
    "*deleted*",
  ];

  if (blacklist.includes(data.username)) {
    return false;
  }

  const userQuery = await usersRef
    .where("username", "==", data.username)
    .get();
  if (userQuery.docs.length > 0 && userQuery.docs[0].id != data.userId) {
    return false;
  }

  return true;
};

const _createBadge = async (data: {
  id: string;
  senderId: string;
  receiverId: string;
  imageUrl: string;
}) => {
  // Checking attribute.
  if (data.senderId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'senderId' cannot be empty"
    );
  }
  if (data.receiverId.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'receiverId' cannot be empty"
    );
  }
  if (data.imageUrl.length === 0) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function argument 'imageUrl' cannot be empty"
    );
  }

  usersRef
    .doc(data.receiverId)
    .update({badgesCount: admin.firestore.FieldValue.increment(1)});

  badgesRef.doc(data.id).set({
    senderId: data.senderId,
    receiverId: data.receiverId,
    imageUrl: data.imageUrl,
  });
};

// --------------------------------------------------------

export const onUserCreated = functions.auth
  .user()
  .onCreate((user: admin.auth.UserRecord) =>
    _createUser({
      id: user.uid,
      email: user.email,
      profilePicture: user.photoURL,
    })
  );
export const onUserDeleted = functions.auth
  .user()
  .onDelete((user: admin.auth.UserRecord) => _deleteUser({id: user.uid}));
export const createUser = functions.https.onCall((data) => _createUser(data));
export const updateUserData = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.id);
  return _updateUserData(data);
});
export const followUser = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.follower);
  return _followUser(data);
});
export const unfollowUser = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.follower);
  return _unfollowUser(data);
});
export const uploadLoop = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.loopUserId);
  return _uploadLoop(data);
});
export const deleteLoop = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.userId);
  return _deleteLoop(data);
});
export const likeLoop = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.currentUserId);
  return _likeLoop(data);
});
export const unlikeLoop = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.currentUserId);
  return _unlikeLoop(data);
});
export const addActivity = functions.https.onCall((data, context) => {
  _authenticated(context);
  return _addActivity(data);
});
export const markActivityAsRead = functions.https.onCall((data, context) => {
  _authenticated(context);
  return _markActivityAsRead(data);
});
export const addComment = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.userId);
  return _addComment(data);
});
export const deleteComment = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.userId);
  return _deleteComment(data);
});
export const shareLoop = functions.https.onCall((data, context) => {
  _authenticated(context);
  return _shareLoop(data);
});
export const checkUsernameAvailability =
  functions.https.onCall((data, context) => {
    _authenticated(context);
    return _checkUsernameAvailability(data);
  });
export const createBadge = functions.https.onCall((data, context) => {
  _authenticated(context);
  _authorized(context, data.senderId);
  return _createBadge(data);
});
