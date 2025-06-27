// @ts-ignore
import { pgTable, varchar, integer, jsonb } from 'drizzle-orm/pg-core';

export const barmon = pgTable('barmon', {
  id: varchar('id', { length: 36 }).primaryKey(),
  name: varchar('name', { length: 32 }),
  eng_name: varchar('eng_name', { length: 32 }),
  types: jsonb('types').$type<string[]>(),
  image_url: varchar('image_url', { length: 128 }),
  level: integer('level'),
  exp: integer('exp'),
  attack: integer('attack'),
  defense: integer('defense'),
  hp: integer('hp'),
  speed: integer('speed'),
  agility: integer('agility'),
  luck: integer('luck'),
  species: varchar('species', { length: 32 }),
  rarity: varchar('rarity', { length: 16 }),
  nature: varchar('nature', { length: 16 }),
  trait: varchar('trait', { length: 16 }),
  potential: integer('potential'),
  star_grade: integer('star_grade'),
  attribute: varchar('attribute', { length: 16 }),
});
