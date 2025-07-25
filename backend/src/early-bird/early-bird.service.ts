import { Injectable } from '@nestjs/common';
import * as nodemailer from 'nodemailer';
import { CreateEarlyBirdDto } from './dto/create-early-bird.dto';
import { EarlyBirdSignup, EmailServiceResponse } from './interfaces/early-bird.interface';

@Injectable()
export class EarlyBirdService {
  private transporter: nodemailer.Transporter;

  constructor() {
    this.transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER || 'your-email@gmail.com',
        pass: process.env.EMAIL_PASS || 'your-app-password',
      },
    });
  }

  async signupEarlyBird(createEarlyBirdDto: CreateEarlyBirdDto): Promise<EmailServiceResponse> {
    try {
      const signupData: EarlyBirdSignup = {
        name: createEarlyBirdDto.name,
        email: createEarlyBirdDto.email,
        phone: createEarlyBirdDto.phone,
        company: createEarlyBirdDto.company,
      };

      const emailContent = this.formatEmailContent(signupData);

      const mailOptions = {
        from: process.env.EMAIL_USER || 'your-email@gmail.com',
        to: 'davidoff.fv@gmail.com',
        subject: 'New Early Bird Signup for Mova',
        html: emailContent,
      };

      await this.transporter.sendMail(mailOptions);

      return {
        success: true,
        message: 'Early bird signup received successfully!',
      };
    } catch (error) {
      console.error('Error sending email:', error);
      return {
        success: false,
        message: 'Failed to process signup. Please try again later.',
      };
    }
  }

  private formatEmailContent(signup: EarlyBirdSignup): string {
    return `
      <h2>New Early Bird Signup for Mova</h2>
      <div style="font-family: Arial, sans-serif; line-height: 1.6;">
        <p><strong>Name:</strong> ${signup.name}</p>
        <p><strong>Email:</strong> ${signup.email}</p>
        ${signup.phone ? `<p><strong>Phone:</strong> ${signup.phone}</p>` : ''}
        ${signup.company ? `<p><strong>Company:</strong> ${signup.company}</p>` : ''}
        <p><strong>Signup Date:</strong> ${new Date().toLocaleString()}</p>
      </div>
    `;
  }
}