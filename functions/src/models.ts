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
  audio: string;
  likes: number;
  downloads: number;
  comments: number;
  shares: number;
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
