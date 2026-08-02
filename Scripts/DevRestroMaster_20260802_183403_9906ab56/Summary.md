# Diagnostics Summary — DevRestroMaster

- **Run ID:** 9906ab56
- **Server:** DESKTOP-9VVHFMK
- **Database:** DevRestroMaster
- **Started (UTC):** 2026-08-02 18:34:03Z
- **Completed (UTC):** 

## Server
- Version: 15.0.2000.5 (RTM, Developer Edition (64-bit))
- CPUs: 4, Memory: 12185 MB, Max server memory: 2147483647 MB
- Clustered: False, HADR: False, Platform: Windows

## Runtime Snapshot
- Active user sessions: 58
- Active blocking chains: 0
- Missing index suggestions: 0
- Unused indexes: 76
- Indexes needing REBUILD (>=30% frag): 1
- Indexes needing REORGANIZE (10-30% frag): 0

### Top Wait Types
| Wait Type | Wait Time (ms) | Waiting Tasks |
|---|---|---|
| SOS_WORK_DISPATCHER | 5,767,277,038 | 55,947,248 |
| HADR_FILESTREAM_IOMGR_IOCOMPLETION | 216,480,545 | 341,132 |
| SQLTRACE_INCREMENTAL_FLUSH_SLEEP | 216,454,774 | 43,288 |
| QDS_PERSIST_TASK_MAIN_LOOP_SLEEP | 216,429,994 | 2,894 |
| ONDEMAND_TASK_QUEUE | 215,997,476 | 16,652,370 |
| RESOURCE_SEMAPHORE | 9,123,274 | 1,287 |
| PREEMPTIVE_XE_GETTARGETSTATE | 261,821 | 5,187 |
| PAGEIOLATCH_SH | 95,684 | 22,398 |
| THREADPOOL | 89,272 | 48,280 |
| LCK_M_X | 75,145 | 373 |

## Health Checks
- **CHECKCATALOG**: PASSED in 1.0s
- **CHECKDB**: PASSED in 14.1s

## Errors
- DatabaseInfo failed: Invalid object name 'sys.query_store_options'.
