import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EarlyBirdController } from './early-bird.controller';
import { EarlyBirdService } from './early-bird.service';
import { EarlyBird } from './entities/early-bird.entity';

@Module({
  imports: [TypeOrmModule.forFeature([EarlyBird])],
  controllers: [EarlyBirdController],
  providers: [EarlyBirdService],
})
export class EarlyBirdModule {}