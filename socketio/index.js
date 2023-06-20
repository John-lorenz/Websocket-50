const { log } = require("console");
const express = require("express");
const { createServer } = require("http");
const { Server } = require("socket.io");
const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

app.route("/").get((req, res) => {
    res.json("Sejam bem vindos");
});

io.on("connection", (socket) => {
    console.log("backend conectado");
    socket.on("sendMsg", (msg) => {
        socket.join("grupo de apostas")
        console.log("msg", msg, );
       // socket.emit("sendMsgServer", { ...msg, type: "otherMsg" });
       io.to("grupo de apostas").emit("sendMsgServer", { ...msg, type: "otherMsg" });
        // Aqui você pode adicionar lógica para lidar com a conexão do socket

    });
});

httpServer.listen(3000, () => {
    console.log("Servidor rodando em http://localhost:3000");
});
