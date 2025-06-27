"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
require("dotenv/config");
const express_1 = __importDefault(require("express"));
const node_postgres_1 = require("drizzle-orm/node-postgres");
const pg_1 = require("pg");
const schema_1 = require("../../drizzle/schema");
const barmon_seed_json_1 = __importDefault(require("../../drizzle/seed/barmon.seed.json"));
console.log('서버 실행 시작');
const app = (0, express_1.default)();
app.use(express_1.default.json());
// PostgreSQL DB 연결
const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
const db = (0, node_postgres_1.drizzle)(pool);
// 바몬 전체 조회 API
app.get('/api/barmon', async (req, res) => {
    const result = await db.select().from(schema_1.barmon);
    res.json(result);
});
// 바몬 시드 데이터 삽입 (최초 1회)
app.post('/api/barmon/seed', async (req, res) => {
    try {
        for (const item of barmon_seed_json_1.default) {
            await db.insert(schema_1.barmon).values(item).onConflictDoNothing();
        }
        res.json({ ok: true });
    }
    catch (e) {
        if (e instanceof Error) {
            res.status(500).json({ error: e.message });
        }
        else {
            res.status(500).json({ error: 'Unknown error' });
        }
    }
});
const port = process.env.PORT || 4000;
app.listen(port, () => {
    console.log(`Starbase API server running on port ${port}`);
});
