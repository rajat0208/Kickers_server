/*
  Warnings:

  - Added the required column `futsalType` to the `TimeSlots` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "TimeSlots" ADD COLUMN     "futsalType" "FutsalType" NOT NULL;
