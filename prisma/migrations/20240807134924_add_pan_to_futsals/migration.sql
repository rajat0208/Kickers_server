/*
  Warnings:

  - A unique constraint covering the columns `[pan]` on the table `futsals` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[googleId]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[facebookId]` on the table `users` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "futsals" ADD COLUMN     "pan" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "futsals_pan_key" ON "futsals"("pan");
