-- CreateTable
CREATE TABLE `AnswerComment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `answerId` INTEGER NOT NULL,
    `userId` TEXT NOT NULL,
    `content` TEXT NOT NULL,
    `createdAt` DATETIME(0) NOT NULL,
    `updatedAt` DATETIME(0) NOT NULL,

    INDEX `AnswerComment_fk0`(`answerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AnswerVoter` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` VARCHAR(255) NOT NULL,
    `answerId` INTEGER NOT NULL,
    `state` INTEGER NOT NULL,

    INDEX `AnswerVoter_fk0`(`userId`),
    INDEX `AnswerVoter_fk1`(`answerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Answer` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `questionId` INTEGER NOT NULL,
    `userId` VARCHAR(255) NOT NULL,
    `content` TEXT NOT NULL,
    `score` INTEGER NOT NULL,
    `verifiy` BOOLEAN NOT NULL,
    `createdAt` DATETIME(0) NOT NULL,
    `updatedAt` DATETIME(0) NOT NULL,

    INDEX `Answer_fk0`(`questionId`),
    INDEX `Answer_fk1`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `QuestionComment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `questionId` INTEGER NOT NULL,
    `userId` TEXT NOT NULL,
    `content` TEXT NOT NULL,
    `createdAt` DATETIME(0) NOT NULL,
    `updatedAt` DATETIME(0) NOT NULL,

    INDEX `QuestionComment_fk0`(`questionId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `QuestionVoter` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `questionId` INTEGER NOT NULL,
    `userId` VARCHAR(255) NOT NULL,
    `state` INTEGER NOT NULL,

    INDEX `QuestionVoter_fk0`(`questionId`),
    INDEX `QuestionVoter_fk1`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Question` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` VARCHAR(255) NOT NULL,
    `title` TEXT NOT NULL,
    `content` TEXT NOT NULL,
    `score` INTEGER NOT NULL,
    `createdAt` DATETIME(0) NOT NULL,
    `updatedAt` DATETIME(0) NOT NULL,

    INDEX `Question_fk0`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Tag` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,

    UNIQUE INDEX `name`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `User` (
    `uid` VARCHAR(255) NOT NULL,
    `reputation` INTEGER NOT NULL,
    `description` TEXT NULL,
    `joiningDate` DATE NOT NULL,
    `displayName` TEXT NOT NULL,
    `photoURL` TEXT NULL,
    `phoneNumber` VARCHAR(20) NULL,
    `email` VARCHAR(255) NOT NULL,

    UNIQUE INDEX `email`(`email`),
    PRIMARY KEY (`uid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Document` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` TEXT NOT NULL,
    `url` TEXT NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TagsOnQuestions` (
    `questionId` INTEGER NOT NULL,
    `tagId` INTEGER NOT NULL,

    INDEX `TagsOnQuestions_fk1`(`tagId`),
    PRIMARY KEY (`questionId`, `tagId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TagsOnUsers` (
    `tagId` INTEGER NOT NULL,
    `userId` VARCHAR(255) NOT NULL,

    INDEX `TagsOnUsers_fk1`(`userId`),
    PRIMARY KEY (`tagId`, `userId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `AnswerComment` ADD CONSTRAINT `AnswerComment_fk0` FOREIGN KEY (`answerId`) REFERENCES `Answer`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `AnswerVoter` ADD CONSTRAINT `AnswerVoter_fk1` FOREIGN KEY (`answerId`) REFERENCES `Answer`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `AnswerVoter` ADD CONSTRAINT `AnswerVoter_fk0` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Answer` ADD CONSTRAINT `Answer_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Answer` ADD CONSTRAINT `Answer_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `QuestionComment` ADD CONSTRAINT `QuestionComment_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `QuestionVoter` ADD CONSTRAINT `QuestionVoter_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `QuestionVoter` ADD CONSTRAINT `QuestionVoter_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Question` ADD CONSTRAINT `Question_fk0` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `TagsOnQuestions` ADD CONSTRAINT `TagsOnQuestions_fk0` FOREIGN KEY (`questionId`) REFERENCES `Question`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `TagsOnQuestions` ADD CONSTRAINT `TagsOnQuestions_fk1` FOREIGN KEY (`tagId`) REFERENCES `Tag`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `TagsOnUsers` ADD CONSTRAINT `TagsOnUsers_fk0` FOREIGN KEY (`tagId`) REFERENCES `Tag`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `TagsOnUsers` ADD CONSTRAINT `TagsOnUsers_fk1` FOREIGN KEY (`userId`) REFERENCES `User`(`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION;
