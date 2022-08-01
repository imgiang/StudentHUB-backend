-- DropForeignKey
ALTER TABLE `TagsOnQuestions` DROP FOREIGN KEY `TagsOnQuestions_fk0`;

-- AlterTable
ALTER TABLE `Answer` MODIFY `score` INTEGER NOT NULL DEFAULT 0,
    MODIFY `verifiy` BOOLEAN NOT NULL DEFAULT false,
    MODIFY `createdAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    MODIFY `updatedAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0);

-- AlterTable
ALTER TABLE `AnswerComment` MODIFY `userId` VARCHAR(255) NOT NULL,
    MODIFY `createdAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    MODIFY `updatedAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0);

-- AlterTable
ALTER TABLE `AnswerVoter` MODIFY `state` INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE `Question` MODIFY `score` INTEGER NOT NULL DEFAULT 0,
    MODIFY `createdAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    MODIFY `updatedAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0);

-- AlterTable
ALTER TABLE `QuestionComment` MODIFY `userId` VARCHAR(255) NOT NULL,
    MODIFY `createdAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    MODIFY `updatedAt` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0);

-- AlterTable
ALTER TABLE `QuestionVoter` MODIFY `state` INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE `User` MODIFY `reputation` INTEGER NOT NULL DEFAULT 0,
    MODIFY `joiningDate` DATE NOT NULL DEFAULT (curdate());

-- CreateIndex
CREATE INDEX `AnswerComment_fk1` ON `AnswerComment`(`userId`);

-- CreateIndex
CREATE FULLTEXT INDEX `Question_title_content_idx` ON `Question`(`title`, `content`);

-- CreateIndex
CREATE INDEX `QuestionComment_fk1` ON `QuestionComment`(`userId`);

-- CreateIndex
CREATE FULLTEXT INDEX `User_displayName_email_idx` ON `User`(`displayName`, `email`);

-- AddForeignKey
ALTER TABLE `AnswerComment` ADD CONSTRAINT `AnswerComment_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `QuestionComment` ADD CONSTRAINT `QuestionComment_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `TagsOnQuestions` ADD CONSTRAINT `TagsOnQuestions_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
