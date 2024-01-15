#include "bar.h"
#include "foo.h"
#include "is_enabled.h"

int main(int argc, char *argv[])
{
	if (IS_ENABLED(CONFIG_FOO))
		foo();
	if (IS_ENABLED(CONFIG_BAR))
		bar();

	return 0;
}
