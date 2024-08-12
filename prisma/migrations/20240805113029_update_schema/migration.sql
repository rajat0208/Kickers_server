/*
  Warnings:

  - You are about to drop the column `amenties` on the `futsals` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "futsals" DROP COLUMN "amenties",
ADD COLUMN     "amenities" TEXT[];
