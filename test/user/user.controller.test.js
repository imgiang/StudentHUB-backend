process.env.NODE_ENV = 'test'

const { expect, assert } = require('chai')
const chai = require('chai')
const chaiHttp = require('chai-http')
const res = require('express/lib/response')
const server = require('../../server')
const users = require('./user.data.test')
chai.use(chaiHttp)

const updateData = {
    displayName: 'Peter',
    phoneNumber: '0975799156',
    description: "I'm batman"
}


describe('Users', () => {

    describe("delete /api/users/{uid}", () => {
        it('it should delete all users', (done) => {
            users.forEach(user => {
                chai.request(server)
                    .delete('/api/users/' + user.uid)
                    .end((err, res) => {
                        assert.equal(res.status, 200)
                    })
            })
            done()
        })
    })

    describe("post /api/users", () => {
        it("it should add all users", done => {

            users.forEach(user => {
                chai.request(server)
                    .post('/api/users')
                    .send(user)
                    .end((err, res) => {
                        assert.equal(res.status, 201)
                        assert.equal(res.body.uid, user.uid)
                    })
            })

            done()
        })
    })

    // describe("get /api/users/1", () => {
    //     it("it should get users[1]", done => {
    //         chai.request(server)
    //             .get("/api/users/" + users[1].uid)
    //             .end((err, res) => {
    //                 // assert.equal(res.status, 200)
    //                 assert.equal(res.body.uid, users[1].uid)
    //                 done()
    //             })

    //     })
    // })

    // describe("put /api/users/1", () => {
    //     it("it should update users[1] with specified data", (done) => {
    //         chai.request(server)
    //             .put("/api/users/" + users[1].uid)
    //             .send(updateData)
    //             .end((err, res) => {
    //                 assert.equal(res.status, 200)
    //                 assert.equal(res.body.displayName, updateData.displayName)
    //                 assert.equal(res.body.phoneNumber, updateData.phoneNumber)
    //                 assert.equal(res.body.description, updateData.description)
    //                 done()

    //             })
    //     })
    // })
    // describe("put /api/users/1", () => {
    //     it("it should not update users[1] with users[0]", (done) => {
    //         chai.request(server)
    //             .put("/api/users/" + users[1].uid)
    //             .send(users[0])
    //             .end((err, res) => {
    //                 assert.equal(res.status, 500)
    //                 done()

    //             })
    //     })
    // })
})