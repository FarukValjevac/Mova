import { Module } from '@nestjs/common';
import { EarlyBirdController } from './early-bird.controller';
import { EarlyBirdService } from './early-bird.service';

@Module({
  controllers: [EarlyBirdController],
  providers: [EarlyBirdService],
})
export class EarlyBirdModule {}