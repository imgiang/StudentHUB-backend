/*
  Warnings:

  - You are about to drop the column `verifiy` on the `Answer` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[facebookId]` on the table `Answer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[facebookId]` on the table `AnswerComment` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[facebookId]` on the table `Question` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[facebookId]` on the table `QuestionComment` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE `Answer` DROP FOREIGN KEY `Answer_fk0`;

-- DropForeignKey
ALTER TABLE `AnswerComment` DROP FOREIGN KEY `AnswerComment_fk0`;

-- DropForeignKey
ALTER TABLE `AnswerVoter` DROP FOREIGN KEY `AnswerVoter_fk1`;

-- DropForeignKey
ALTER TABLE `AnswerVoter` DROP FOREIGN KEY `AnswerVoter_fk0`;

-- DropForeignKey
ALTER TABLE `QuestionComment` DROP FOREIGN KEY `QuestionComment_fk0`;

-- DropForeignKey
ALTER TABLE `QuestionVoter` DROP FOREIGN KEY `QuestionVoter_fk0`;

-- DropForeignKey
ALTER TABLE `QuestionVoter` DROP FOREIGN KEY `QuestionVoter_fk1`;

-- DropForeignKey
ALTER TABLE `TagsOnUsers` DROP FOREIGN KEY `TagsOnUsers_fk1`;

-- AlterTable
ALTER TABLE `Answer` DROP COLUMN `verifiy`,
    ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `facebookId` VARCHAR(31) NULL,
    ADD COLUMN `verify` BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE `AnswerComment` ADD COLUMN `facebookId` VARCHAR(31) NULL;

-- AlterTable
ALTER TABLE `Question` ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `facebookId` VARCHAR(31) NULL,
    MODIFY `title` VARCHAR(255) NOT NULL;

-- AlterTable
ALTER TABLE `QuestionComment` ADD COLUMN `facebookId` VARCHAR(31) NULL;

-- AlterTable
ALTER TABLE `User` MODIFY `displayName` VARCHAR(255) NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX `facebookId` ON `Answer`(`facebookId`);

-- CreateIndex
CREATE UNIQUE INDEX `facebookId` ON `AnswerComment`(`facebookId`);

-- CreateIndex
CREATE UNIQUE INDEX `facebookId` ON `Question`(`facebookId`);

-- CreateIndex
CREATE UNIQUE INDEX `facebookId` ON `QuestionComment`(`facebookId`);

-- AddForeignKey
ALTER TABLE `AnswerComment` ADD CONSTRAINT `AnswerComment_fk0` FOREIGN KEY (`answerId`) REFERENCES `Answer`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `AnswerVoter` ADD CONSTRAINT `AnswerVoter_fk1` FOREIGN KEY (`answerId`) REFERENCES `Answer`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `AnswerVoter` ADD CONSTRAINT `AnswerVoter_fk0` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Answer` ADD CONSTRAINT `Answer_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `QuestionComment` ADD CONSTRAINT `QuestionComment_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `QuestionVoter` ADD CONSTRAINT `QuestionVoter_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `QuestionVoter` ADD CONSTRAINT `QuestionVoter_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `TagsOnUsers` ADD CONSTRAINT `TagsOnUsers_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- RenameIndex
ALTER TABLE `Question` RENAME INDEX `Question_title_content_idx` TO `title`;

-- RenameIndex
ALTER TABLE `User` RENAME INDEX `User_displayName_email_idx` TO `displayName`;
