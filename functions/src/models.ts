type AccountType = "free" | "venue";

type UserModel = {
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
};

type Badge = {
  id: string;
  senderId: string;
  receiverId: string;
  imageUrl: string;
};

type Loop = {
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
