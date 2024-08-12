/*
  Warnings:

  - Made the column `pan` on table `futsals` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "futsals" ALTER COLUMN "pan" SET NOT NULL;
