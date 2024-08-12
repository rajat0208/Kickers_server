/*
  Warnings:

  - A unique constraint covering the columns `[email]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[phone]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[password]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `address` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `email` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `image` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `password` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `phone` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `roleId` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "FutsalType" AS ENUM ('FiveA', 'SevenA');

-- CreateEnum
CREATE TYPE "Payment" AS ENUM ('Pending', 'Paid');

-- CreateEnum
CREATE TYPE "RequestStatus" AS ENUM ('Pending', 'Accepted', 'Cancelled');

-- CreateEnum
CREATE TYPE "MatchStatus" AS ENUM ('Cancelled', 'Scheduled');

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "address" TEXT NOT NULL,
ADD COLUMN     "email" TEXT NOT NULL,
ADD COLUMN     "image" TEXT NOT NULL,
ADD COLUMN     "password" TEXT NOT NULL,
ADD COLUMN     "phone" TEXT NOT NULL,
ADD COLUMN     "roleId" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "roles" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "futsals" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "type" "FutsalType" NOT NULL,
    "startTime" TIME NOT NULL,
    "endTime" TIME NOT NULL,
    "amenties" TEXT[],
    "images" TEXT[],
    "stdPrice" INTEGER NOT NULL,
    "rating" DECIMAL(10,1) NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "futsals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "price_lists" (
    "id" SERIAL NOT NULL,
    "startTime" TIME NOT NULL,
    "endTime" TIME NOT NULL,
    "dayOfWeek" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "futsalId" INTEGER NOT NULL,

    CONSTRAINT "price_lists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bookings" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "futsalId" INTEGER NOT NULL,
    "bookDate" DATE NOT NULL,
    "startTime" TIME NOT NULL,
    "endTime" TIME NOT NULL,
    "type" "FutsalType" NOT NULL,
    "price" INTEGER NOT NULL,
    "paymentStatus" "Payment" NOT NULL,

    CONSTRAINT "bookings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TimeSlots" (
    "id" SERIAL NOT NULL,
    "startTime" TIME NOT NULL,
    "endTime" TIME NOT NULL,
    "date" DATE NOT NULL,
    "price" INTEGER NOT NULL,
    "futsalId" INTEGER NOT NULL,

    CONSTRAINT "TimeSlots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MatchRequest" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "futsalName" TEXT NOT NULL,
    "futsalType" "FutsalType" NOT NULL,
    "matchDate" DATE NOT NULL,
    "startTime" TIME NOT NULL,
    "endTime" TIME NOT NULL,
    "matchType" TEXT NOT NULL,
    "status" "RequestStatus" NOT NULL DEFAULT 'Pending',

    CONSTRAINT "MatchRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Matches" (
    "id" SERIAL NOT NULL,
    "futsalName" TEXT NOT NULL,
    "futsalType" "FutsalType" NOT NULL,
    "matchType" TEXT NOT NULL,
    "matchDate" DATE NOT NULL,
    "startTime" TIME NOT NULL,
    "endTime" TIME NOT NULL,
    "status" "MatchStatus" NOT NULL DEFAULT 'Scheduled',
    "organizerId" INTEGER NOT NULL,
    "opponentId" INTEGER NOT NULL,

    CONSTRAINT "Matches_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "futsals_phone_key" ON "futsals"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "futsals_userId_key" ON "futsals"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "MatchRequest_userId_key" ON "MatchRequest"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Matches_organizerId_key" ON "Matches"("organizerId");

-- CreateIndex
CREATE UNIQUE INDEX "Matches_opponentId_key" ON "Matches"("opponentId");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "users_password_key" ON "users"("password");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "futsals" ADD CONSTRAINT "futsals_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "price_lists" ADD CONSTRAINT "price_lists_futsalId_fkey" FOREIGN KEY ("futsalId") REFERENCES "futsals"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_futsalId_fkey" FOREIGN KEY ("futsalId") REFERENCES "futsals"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TimeSlots" ADD CONSTRAINT "TimeSlots_futsalId_fkey" FOREIGN KEY ("futsalId") REFERENCES "futsals"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MatchRequest" ADD CONSTRAINT "MatchRequest_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Matches" ADD CONSTRAINT "Matches_organizerId_fkey" FOREIGN KEY ("organizerId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Matches" ADD CONSTRAINT "Matches_opponentId_fkey" FOREIGN KEY ("opponentId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
