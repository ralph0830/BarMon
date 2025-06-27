"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.barmon = void 0;
// @ts-ignore
const pg_core_1 = require("drizzle-orm/pg-core");
exports.barmon = (0, pg_core_1.pgTable)('barmon', {
    id: (0, pg_core_1.varchar)('id', { length: 36 }).primaryKey(),
    name: (0, pg_core_1.varchar)('name', { length: 32 }),
    engName: (0, pg_core_1.varchar)('eng_name', { length: 32 }),
    types: (0, pg_core_1.jsonb)('types').$type(),
    imageUrl: (0, pg_core_1.varchar)('image_url', { length: 128 }),
    level: (0, pg_core_1.integer)('level'),
    exp: (0, pg_core_1.integer)('exp'),
    attack: (0, pg_core_1.integer)('attack'),
    defense: (0, pg_core_1.integer)('defense'),
    hp: (0, pg_core_1.integer)('hp'),
    speed: (0, pg_core_1.integer)('speed'),
    agility: (0, pg_core_1.integer)('agility'),
    luck: (0, pg_core_1.integer)('luck'),
    species: (0, pg_core_1.varchar)('species', { length: 32 }),
    rarity: (0, pg_core_1.varchar)('rarity', { length: 16 }),
    nature: (0, pg_core_1.varchar)('nature', { length: 16 }),
    trait: (0, pg_core_1.varchar)('trait', { length: 16 }),
    potential: (0, pg_core_1.integer)('potential'),
    starGrade: (0, pg_core_1.integer)('star_grade'),
    attribute: (0, pg_core_1.varchar)('attribute', { length: 16 }),
});
