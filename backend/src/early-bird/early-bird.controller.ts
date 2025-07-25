import { Controller, Post, Body, ValidationPipe, HttpCode, HttpStatus } from '@nestjs/common';
import { EarlyBirdService } from './early-bird.service';
import { CreateEarlyBirdDto } from './dto/create-early-bird.dto';
import { EmailServiceResponse } from './interfaces/early-bird.interface';

@Controller('early-bird')
export class EarlyBirdController {
  constructor(private readonly earlyBirdService: EarlyBirdService) {}

  @Post('signup')
  @HttpCode(HttpStatus.OK)
  async signup(
    @Body(new ValidationPipe()) createEarlyBirdDto: CreateEarlyBirdDto,
  ): Promise<EmailServiceResponse> {
    return this.earlyBirdService.signupEarlyBird(createEarlyBirdDto);
  }
}