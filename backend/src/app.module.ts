import { Module } from '@nestjs/common';
import { EarlyBirdModule } from './early-bird/early-bird.module';

@Module({
  imports: [EarlyBirdModule],
})
export class AppModule {}