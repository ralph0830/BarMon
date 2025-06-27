"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const express_1 = __importDefault(require("express"));
const node_postgres_1 = require("drizzle-orm/node-postgres");
const pg_1 = require("pg");
const schema_1 = require("../schema");
const barmonSeed = require('./seed/barmon.seed.json');
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
        for (const item of barmonSeed) {
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
// 바몬 소환(스캔) API
app.post('/api/barmon/scan', (req, res) => {
    (async () => {
        const { barcode, accountId } = req.body;
        if (!barcode || !accountId) {
            return res.status(400).json({ error: 'barcode, accountId required' });
        }
        // 바몬 생성 로직(임시: 바코드+계정ID 해시 기반)
        // 실제로는 barmon_generator와 동일한 로직을 Node.js로 구현 필요
        // 여기서는 임시로 랜덤/고정 데이터 반환
        const id = `${accountId}_${barcode}`;
        const newBarMon = {
            id,
            name: `바몬_${barcode.substring(0, 4)}`,
            eng_name: `BarMon_${barcode.substring(0, 4)}`,
            types: ['normal'],
            image_url: 'AbyssGuardian.png',
            level: 1,
            exp: 0,
            attack: 100,
            defense: 100,
            hp: 200,
            speed: 50,
            agility: 50,
            luck: 50,
            species: '야수',
            rarity: 'normal',
            nature: '밸런스형',
            trait: '기본',
            potential: 50,
            star_grade: 1,
            attribute: '무속성',
        };
        // DB에 중복 없으면 삽입
        try {
            await db.insert(schema_1.barmon).values(newBarMon).onConflictDoNothing();
            res.json(newBarMon);
        }
        catch (e) {
            res.status(500).json({ error: e instanceof Error ? e.message : 'Unknown error' });
        }
    })();
});
const port = process.env.PORT || 4000;
app.listen(port, () => {
    console.log(`Starbase API server running on port ${port}`);
});
