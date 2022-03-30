[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
$cleanupScope = new-object Microsoft.UpdateServices.Administration.CleanupScope;
# $cleanupScope.DeclineSupersededUpdates = $true # Performed by CM1906
# $cleanupScope.DeclineExpiredUpdates    = $true # Performed by CM1906
# $cleanupScope.CleanupObsoleteUpdates   = $true # Performed by CM1906
$cleanupScope.CompressUpdates          = $true
$cleanupScope.CleanupObsoleteComputers = $true
$cleanupScope.CleanupUnneededContentFiles = $true
$cleanupManager = $wsus.GetCleanupManager();
$cleanupManager.PerformCleanup($cleanupScope) | Out-File C:\WSUS\WsusClean.txt;