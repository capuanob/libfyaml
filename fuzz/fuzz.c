#include <stdint.h> //uint8_t
#include <libfyaml.h>

int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    struct fy_document *fyd = NULL;
    fyd = fy_document_build_from_string(NULL, (const char*) data, size);
    fy_document_destroy(fyd); //cleanup
    return 0;
}
