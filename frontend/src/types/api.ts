export interface EarlyBirdSignup {
  name: string;
  email: string;
  phone?: string;
  company?: string;
}

export interface ApiResponse {
  success: boolean;
  message: string;
}