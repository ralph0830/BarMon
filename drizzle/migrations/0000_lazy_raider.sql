CREATE TABLE "barmon_master" (
	"id" varchar(36) PRIMARY KEY NOT NULL,
	"name" varchar(32),
	"eng_name" varchar(32),
	"types" jsonb,
	"image_url" varchar(128),
	"base_attack" integer,
	"base_defense" integer,
	"base_hp" integer,
	"base_agility" integer,
	"base_luck" integer,
	"species" varchar(32),
	"rarity" varchar(24),
	"attribute" varchar(16)
);
--> statement-breakpoint
CREATE TABLE "user_barmon" (
	"id" varchar(36) PRIMARY KEY NOT NULL,
	"user_id" varchar(36),
	"barmon_id" varchar(36),
	"acquired_hp" integer,
	"acquired_attack" integer,
	"acquired_defense" integer,
	"acquired_agility" integer,
	"acquired_luck" integer,
	"level" integer DEFAULT 1,
	"exp" integer DEFAULT 0,
	"potential" integer,
	"nature" varchar(16),
	"trait" varchar(16),
	"star_grade" integer,
	"created_at" varchar(32)
);
