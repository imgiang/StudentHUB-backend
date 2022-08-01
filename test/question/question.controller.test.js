process.env.NODE_ENV = 'test'

const { assert } = require('chai')
const chaiHttp = require('chai-http')
const chai = require('chai')
const server = require('../../server')
const { questions } = require('../question/question.data.test')

require('../user/user.controller.test')

chai.use(chaiHttp)

describe('Questions', () => {

    before(() => {
        chai.request(server)
            .delete("/api/questions")
            .end((err, res) => {

            })
    })

    describe("POST /api/questions", () => {
        it('it should add all questions', done => {
            questions.forEach(question => {
                chai.request(server)
                    .post('/api/questions')
                    .send(question)
                    .end((err, res) => {
                        assert.equal(res.status, 201)
                        assert.equal(res.body.userId, question.userId)
                        assert.equal(res.body.content, question.content)
                    })
            })
            done()
        })
    })

    describe('GET /api/questions', () => {
        it('it should get all questions', (done) => {
            chai.request(server)
                .get("/api/questions")
                .end((err, res) => {
                    assert.equal(res.status, 200)
                    assert.equal(res.body.length, 6)
                    done()
                })
        })
    })

})