---
description: Task as Finite State Machine (FSM)
---

# Task State Transitions

## State Transition Graph

A complete task state transition graph is given below:

```mermaid fullWidth="true"
stateDiagram-v2
  state "Queued" as q
  state "Started" as s
  state "Parameters Uploaded" as pu
  state "Error Reported" as er
  state "Score Ready" as sr
  state "Validated" as v
  state "End Success" as es
  state "End Invalidated" as ei
  state "End Aborted" as ea

  [*] --> q: App - create task
  [*] --> s: App - create task
  q --> s: Blockchain - start task
  s --> pu: Relay - report parameters uploaded
  pu --> sr: Node - submit task score
  pu --> er: Node - report task error
  sr --> es: App - validate task group
  sr --> ei: App - validate task group
  sr --> v: App - validate single task<br/>App - validate task group
  q --> ea: App - abort task
  s --> ea: App/Node - abort task
  pu --> ea: App/Node - abort task
  er --> ea: App - validate single task<br/>App - validate task group<br/>App/Node - abort task
  er --> ei: App - validate task group
  sr --> ea: App/Node - abort task
  v --> ea: App/Node - abort task
  v --> es: Relay - report result uploaded
  ea --> ea: App - validate task group
  es --> [*]
  ei --> [*]
  ea --> [*]
```



## Group Validation Results

When a task is validated in a validation group, its result state is determined according to the table below:

<table data-full-width="true"><thead><tr><th width="105">Task 1</th><th width="94">Task 2</th><th width="95">Task 3</th><th>Task 1</th><th>Task 2</th><th>Task 3</th></tr></thead><tbody><tr><td>Score A</td><td>Score A</td><td>Score A</td><td>Validated</td><td>EndSuccess</td><td>EndSuccess</td></tr><tr><td>Score A</td><td>Score A</td><td>Score B</td><td>Validated</td><td>EndSuccess</td><td>EndInvalidated</td></tr><tr><td>Score A</td><td>Score B</td><td>Score C</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Score A</td><td>Score A</td><td>Report Error</td><td>Validated</td><td>EndSuccess</td><td>EndInvalidated</td></tr><tr><td>Score A</td><td>Score B</td><td>Report Error</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Score A</td><td>Score A</td><td>Abort</td><td>Validated</td><td>EndSuccess</td><td>EndAborted</td></tr><tr><td>Score A</td><td>Score B</td><td>Abort</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Score</td><td>Report Error</td><td>Report Error</td><td>EndInvalidated</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Score</td><td>Report Error</td><td>Abort</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Score</td><td>Abort</td><td>Abort</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Report Error</td><td>Report Error</td><td>Report Error</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Report Error</td><td>Report Error</td><td>Abort</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Report Error</td><td>Abort</td><td>Abort</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr><tr><td>Abort</td><td>Abort</td><td>Abort</td><td>EndAborted</td><td>EndAborted</td><td>EndAborted</td></tr></tbody></table>
