import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EarlyBirdModule } from './early-bird/early-bird.module';
import { EarlyBird } from './early-bird/entities/early-bird.entity';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT) || 5433,
      username: process.env.DB_USERNAME || 'mova_user',
      password: process.env.DB_PASSWORD || 'mova_password',
      database: process.env.DB_NAME || 'mova_db',
      entities: [EarlyBird],
      synchronize: process.env.NODE_ENV !== 'production',
    }),
    EarlyBirdModule,
  ],
})
export class AppModule {}