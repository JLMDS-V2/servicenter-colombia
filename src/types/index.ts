export type UserRole = 'user' | 'seller';

export interface User {
  id: string;
  email: string;
  role: UserRole;
  location: string;
  city: string;
  full_name?: string;
  phone?: string;
  created_at: string;
}

export interface Seller extends User {
  role: 'seller';
  categories: string[];
  description?: string;
  whatsapp?: string;
  preferred_contact: 'whatsapp' | 'chat' | 'both';
  is_verified: boolean;
  subscription_end?: string;
  rating: number;
  review_count: number;
}

export interface Category {
  id: string;
  name: string;
  icon: string;
  description: string;
}

export interface Review {
  id: string;
  seller_id: string;
  user_id: string;
  rating: number;
  comment: string;
  created_at: string;
  user_name?: string;
}

export interface Message {
  id: string;
  conversation_id: string;
  sender_id: string;
  receiver_id: string;
  content: string;
  created_at: string;
  read: boolean;
}

export interface Conversation {
  id: string;
  user_id: string;
  seller_id: string;
  last_message?: string;
  last_message_time?: string;
  created_at: string;
}

export interface City {
  id: string;
  name: string;
  department: string;
}
