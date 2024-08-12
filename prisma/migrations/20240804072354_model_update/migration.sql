-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('Pending', 'Confirmed', 'Cancelled');

-- AlterTable
ALTER TABLE "bookings" ADD COLUMN     "confirmation" "BookingStatus" NOT NULL DEFAULT 'Pending',
ALTER COLUMN "paymentStatus" SET DEFAULT 'Pending';
