import { IsEmail, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateEarlyBirdDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsNotEmpty()
  @IsEmail()
  email: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  company?: string;
}