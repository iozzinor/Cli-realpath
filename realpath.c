#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
	// use the current working directory path if the filename is not provided
	if (argc < 2)
	{
		printf("%s\n", getenv("PWD"));
		return EXIT_SUCCESS;
	}

	char const * const target_path = argv[1];
	char * const target_real_path = realpath(target_path, NULL);
	if (target_real_path == NULL)
	{
		return EXIT_FAILURE;
	}
	printf("%s\n", target_real_path);
	free(target_real_path);

	return EXIT_SUCCESS;
}

