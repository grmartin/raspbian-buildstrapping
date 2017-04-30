#include <iostream>
#include <mongo/client/dbclient.h>

int main() {
    std::cout << "Started." << std::endl;

    mongo::DBClientConnection* dbc = new mongo::DBClientConnection();

    dbc->connect(getenv("PIBS_MONGO_HOST"));

    if (dbc->isFailed()) {
        std::cerr << "Connection failed! Did you set the 'PIBS_MONGO_HOST' environment variable?" << std::endl;
    } else {
        std::cout << "Connected!." << std::endl;
    }

    return 0;
}
