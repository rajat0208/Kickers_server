/*
  Warnings:

  - You are about to drop the column `images` on the `futsals` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "futsals" DROP COLUMN "images";

-- CreateTable
CREATE TABLE "FutsalImage" (
    "id" SERIAL NOT NULL,
    "url" TEXT NOT NULL,
    "futsalId" INTEGER NOT NULL,

    CONSTRAINT "FutsalImage_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "FutsalImage" ADD CONSTRAINT "FutsalImage_futsalId_fkey" FOREIGN KEY ("futsalId") REFERENCES "futsals"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
