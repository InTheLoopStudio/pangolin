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
  toUserId: string;
  // timestamp: firestore.Timestamp;
  // markedRead: boolean;
}
export type UserToUserActivity = Activity & { fromUserId: string }
export type FollowActivity = UserToUserActivity & { type: "follow", }
export type LikeActivity = UserToUserActivity & { type: "like"; loopId: string }
export type CommentActivity = UserToUserActivity & { type: "comment", rootId: string, commentId: string }
export type BookingRequestActivity = UserToUserActivity & { type: "bookingRequest", bookingId: string }
export type BookingUpdateActivity = UserToUserActivity & { type: "bookingUpdate", bookingId: string, status: BookingStatus }
export type LoopMentionActivity = UserToUserActivity & { type: "loopMention", loopId: string }
export type CommentMentionActivity = UserToUserActivity & { type: "commentMention", rootId: string, commentId: string; }
export type CommentLikeActivity = UserToUserActivity & { type: "commentLike", rootId: string, commentId: string; }
export type OpportunityInterest = UserToUserActivity & { type: "opportunityInterest", loopId: string; }
export type BookingReminderActivity = UserToUserActivity & { type: "bookingReminder", bookingId: string; }
export type SearchAppearanceActivity = Activity & { type: "searchAppearance", count: number; }

export type BookingStatus = "pending" | "confirmed" | "canceled"
