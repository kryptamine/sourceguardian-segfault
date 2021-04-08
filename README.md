## Steps to reproduce
1. Encode `/app/Http/Controllers/TestController.php` via SourceGuardian 12(--phpversion=8)
2. Build the container `docker build -t segfault .`
3. Run the container several times(if needed), `docker run segfault` until it leads to segmentation fault
