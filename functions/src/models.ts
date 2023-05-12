import { firestore } from "firebase-admin";

export type AccountType = "free" | "venue";

export type UserModel = {
  id: string;
  email?: string;
  username?: string;
  artistName?: string;
  bio?: string;
  profilePicture?: string;
  location?: string;
  onboarded?: boolean;
  loopsCount?: number;
  badgesCount?: number;
  deleted?: boolean;
  shadowBanned?: boolean;
  accountType?: AccountType;
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
  bookingRate?: number;
  stripeConnectedAccountId?: string;
  stripeCustomerId?: string;
};

export type Badge = {
  id: string;
  name: string;
  creatorId: string;
  imageUrl: string;
  description: string;
};

export type Loop = {
  id: string;
  userId: string;
  title: string;
  description: string;
  audioPath: string;
  likeCount: number;
  downloads: number;
  commentCount: number;
  shareCount: number;
  imagePaths: Array<string>;
  tags: Array<string>;
  deleted: boolean;
};

export type Comment = {
  visitedUserId: string;
  rootLoopId: string;
  userId: string;
  content: string;
  parentId: string | null;
  children: Array<string>;
};

export type Booking = {
  id: string;
  serviceId: string;
  name: string;
  note: string;
  requesterId: string;
  requesteeId: string;
  status: string;
  rate: number;
  startTime: firestore.Timestamp;
  endTime: firestore.Timestamp;
  timestamp: firestore.Timestamp;
}

export type Activity = {
  // id: string;
  fromUserId: string;
  toUserId: string;
  // timestamp: firestore.Timestamp;
  // markedRead: boolean;
}

export type FollowActivity = Activity & { type: "follow" }
export type LikeActivity = Activity & { type: "like"; loopId: string }
export type CommentActivity = Activity & { type: "comment", rootId: string, commentId: string }
export type BookingRequestActivity = Activity & { type: "bookingRequest", bookingId: string }
export type BookingUpdateActivity = Activity & { type: "bookingUpdate", bookingId: string, status: BookingStatus }
export type LoopMentionActivity = Activity & { type: "loopMention", loopId: string }
export type CommentMentionActivity = Activity & { type: "commentMention", rootId: string, commentId: string; }

export type BookingStatus = "pending" | "confirmed" | "canceled"
