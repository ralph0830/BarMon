import 'dotenv/config';
import type { Config } from 'drizzle-kit';
// process 타입 오류가 발생하면 @types/node를 devDependencies에 설치하세요.

export default {
  schema: './schema.ts',
  out: './migrations',
  dialect: 'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
  strict: true,
  verbose: true,
} satisfies Config; 