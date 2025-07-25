export interface EarlyBirdSignup {
  name: string;
  email: string;
  phone?: string;
  company?: string;
}

export interface EmailServiceResponse {
  success: boolean;
  message: string;
}