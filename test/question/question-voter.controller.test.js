process.env.NODE_ENV = 'test'

const chai = require('chai')
const assert = chai.assert
const chaiHttp = require('chai-http')
const { describe } = require('mocha')
chai.use(chaiHttp)
const server = require('../../server')

require("../question/question.controller.test")

describe('Question Voter', () => {
    describe("PUT /questions/score/1", () => {
        it('it should update score of question 1', done => {
            chai.request(server)
                .put("/api/questions/score/1")
                .send({
                    userId: 1,
                    questionId: 24,
                    state: 1
                })
                .end((err, res) => {
                    assert.equal(res.status, 200)
                })
            done()
        })
    })
    server.close()
})