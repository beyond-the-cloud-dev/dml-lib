<template>
  <div
    ref="containerRef"
    class="unit-of-work-animation"
    role="region"
    aria-label="Unit of Work DML Animation"
    tabindex="0"
    @keydown="handleKeydown"
  >
    <!-- Visually hidden live region for screen reader announcements -->
    <div
      aria-live="polite"
      aria-atomic="true"
      class="sr-only"
    >
      {{ ariaLiveMessage }}
    </div>

    <!-- Header -->
    <div class="animation-header">
      <h2 class="animation-title">Unit of Work — Dependency Resolution</h2>
      <p class="animation-subtitle">17 records → 12 DML statements</p>
    </div>

    <!-- Animation Controls -->
    <AnimationControls
      :is-playing="isPlaying"
      :current-step="currentStep"
      :total-steps="dmlSteps.length"
      :speed="speed"
      @play="play"
      @pause="pause"
      @next="nextStep"
      @previous="previousStep"
      @reset="reset"
      @speed-change="setSpeed"
    />

    <!-- Progress Bar -->
    <ProgressBar
      :current="currentStep"
      :total="dmlSteps.length"
    />

    <!-- Main Content Grid -->
    <div class="content-grid">
      <!-- Graph Canvas -->
      <div class="graph-section">
        <GraphCanvas
          :nodes="nodes"
          :edges="edges"
          :node-positions="nodePositions"
          :node-states="nodeStates"
          :active-edges="activeEdges"
          @node-click="handleNodeClick"
          @node-hover="handleNodeHover"
          @node-leave="handleNodeLeave"
          @edge-hover="handleEdgeHover"
          @edge-leave="handleEdgeLeave"
        />
      </div>

      <!-- DML Table -->
      <div class="table-section">
        <DmlTable
          :steps="dmlSteps"
          :current-step="currentStep"
          @step-click="jumpToStep"
        />
      </div>
    </div>

    <!-- Step Description -->
    <StepDescription :step-info="currentStepInfo" />

    <!-- Keyboard Shortcuts Help -->
    <details class="keyboard-help">
      <summary class="help-summary">⌨️ Keyboard Shortcuts</summary>
      <dl class="help-list">
        <div class="help-item">
          <dt>Space / K</dt>
          <dd>Play/Pause</dd>
        </div>
        <div class="help-item">
          <dt>→ / L</dt>
          <dd>Next step</dd>
        </div>
        <div class="help-item">
          <dt>← / J</dt>
          <dd>Previous step</dd>
        </div>
        <div class="help-item">
          <dt>Home / 0</dt>
          <dd>Reset to start</dd>
        </div>
        <div class="help-item">
          <dt>Esc</dt>
          <dd>Clear selection</dd>
        </div>
      </dl>
    </details>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { nodes, edges, dmlSteps } from '../data/graphData.js'
import { calculateGraphLayout } from '../composables/useGraphLayout.js'
import { useAutoPlay } from '../composables/useIntersectionObserver.js'
import AnimationControls from './AnimationControls.vue'
import ProgressBar from './ProgressBar.vue'
import StepDescription from './StepDescription.vue'
import DmlTable from './DmlTable.vue'
import GraphCanvas from './GraphCanvas.vue'

// ============================================================================
// ANIMATION STATE
// ============================================================================
const currentStep = ref(0)
const isPlaying = ref(false)
const speed = ref(1)
const animationTimerRef = ref(null)

// ============================================================================
// UI INTERACTION STATE
// ============================================================================
const selectedNode = ref(null)
const hoveredNode = ref(null)
const hoveredEdge = ref(null)

// ============================================================================
// ACCESSIBILITY STATE
// ============================================================================
const ariaLiveMessage = ref('')
const announceTimeout = ref(null)

// ============================================================================
// REFS FOR DOM ELEMENTS
// ============================================================================
const containerRef = ref(null)

// ============================================================================
// COMPUTED - LAYOUT POSITIONS
// ============================================================================
const nodePositions = computed(() => {
  return calculateGraphLayout(nodes, edges)
})

// ============================================================================
// COMPUTED - DERIVED ANIMATION STATE
// ============================================================================
const processedRecords = computed(() => {
  const processed = new Set()
  for (let i = 0; i < currentStep.value; i++) {
    dmlSteps[i].records.forEach(id => processed.add(id))
  }
  return processed
})

const currentRecords = computed(() => {
  if (currentStep.value >= dmlSteps.length) return new Set()
  return new Set(dmlSteps[currentStep.value].records)
})

const activeEdges = computed(() => {
  const active = []
  edges.forEach(edge => {
    if (currentRecords.value.has(edge.from) || currentRecords.value.has(edge.to)) {
      active.push(edge)
    }
  })
  return active
})

// ============================================================================
// COMPUTED - NODE STATES (for rendering)
// ============================================================================
const nodeStates = computed(() => {
  const states = new Map()

  nodes.forEach(node => {
    let state = 'pending'

    if (processedRecords.value.has(node.id)) {
      state = 'done'
    } else if (currentRecords.value.has(node.id)) {
      state = 'active'
    }

    const isHovered = hoveredNode.value === node.id
    const isSelected = selectedNode.value === node.id

    states.set(node.id, { state, isHovered, isSelected })
  })

  return states
})

// ============================================================================
// COMPUTED - CURRENT STEP INFO (for description display)
// ============================================================================
const currentStepInfo = computed(() => {
  if (currentStep.value === 0) {
    return {
      title: 'Ready to Start',
      description: 'Press Play to begin the animation showing how DML Lib processes 17 records in 12 optimized DML statements.',
      operation: null,
      sobject: null,
      recordCount: 0,
      stepNumber: null
    }
  }

  if (currentStep.value > dmlSteps.length) {
    return {
      title: 'Animation Complete',
      description: '✓ All DML operations executed successfully. DML Lib processed 17 records using only 12 DML statements through intelligent dependency resolution and record bucketing.',
      operation: null,
      sobject: null,
      recordCount: 0,
      stepNumber: null
    }
  }

  const step = dmlSteps[currentStep.value - 1]
  return {
    title: `Step ${currentStep.value} of ${dmlSteps.length}`,
    description: step.description,
    operation: step.operation,
    sobject: step.sobject,
    recordCount: step.records.length,
    stepNumber: currentStep.value
  }
})

// ============================================================================
// METHODS - ANIMATION CONTROL
// ============================================================================
function play() {
  if (currentStep.value >= dmlSteps.length) {
    reset()
  }
  isPlaying.value = true
}

function pause() {
  isPlaying.value = false
}

function reset() {
  currentStep.value = 0
  isPlaying.value = false
  selectedNode.value = null
  announceStepChange(0)
}

function nextStep() {
  if (currentStep.value < dmlSteps.length) {
    currentStep.value++
  } else {
    pause()
  }
}

function previousStep() {
  if (currentStep.value > 0) {
    currentStep.value--
  }
}

function setSpeed(newSpeed) {
  speed.value = newSpeed
}

function jumpToStep(stepIndex) {
  currentStep.value = stepIndex
  pause()
}

// ============================================================================
// METHODS - INTERACTION
// ============================================================================
function handleNodeClick(nodeId) {
  selectedNode.value = selectedNode.value === nodeId ? null : nodeId
}

function handleNodeHover(nodeId) {
  hoveredNode.value = nodeId
}

function handleNodeLeave() {
  hoveredNode.value = null
}

function handleEdgeHover(edge) {
  hoveredEdge.value = edge
}

function handleEdgeLeave() {
  hoveredEdge.value = null
}

// ============================================================================
// METHODS - ACCESSIBILITY
// ============================================================================
function announceStepChange(stepIndex) {
  if (announceTimeout.value) {
    clearTimeout(announceTimeout.value)
  }

  let message = ''

  if (stepIndex === 0) {
    message = 'Animation reset. Ready to start.'
  } else if (stepIndex > dmlSteps.length) {
    message = 'Animation complete. All DML operations executed.'
  } else {
    const step = dmlSteps[stepIndex - 1]
    message = `Step ${stepIndex} of ${dmlSteps.length}. ${step.operation} ${step.records.length} ${step.sobject} ${step.records.length === 1 ? 'record' : 'records'}. ${step.description}`
  }

  announceTimeout.value = setTimeout(() => {
    ariaLiveMessage.value = message
  }, 100)
}

function handleKeydown(event) {
  // Only handle if component has focus or keyboard focus is inside
  if (!containerRef.value?.contains(document.activeElement)) {
    return
  }

  switch (event.key) {
    case ' ':
    case 'k':
    case 'K':
      event.preventDefault()
      isPlaying.value ? pause() : play()
      break

    case 'ArrowRight':
    case 'l':
    case 'L':
      event.preventDefault()
      nextStep()
      break

    case 'ArrowLeft':
    case 'j':
    case 'J':
      event.preventDefault()
      previousStep()
      break

    case 'Home':
    case '0':
      event.preventDefault()
      reset()
      break

    case 'Escape':
      event.preventDefault()
      selectedNode.value = null
      break
  }
}

// ============================================================================
// WATCHERS
// ============================================================================
watch([isPlaying, speed], () => {
  if (animationTimerRef.value) {
    clearInterval(animationTimerRef.value)
    animationTimerRef.value = null
  }

  if (isPlaying.value) {
    const interval = 2000 / speed.value
    animationTimerRef.value = setInterval(() => {
      nextStep()
    }, interval)
  }
})

watch(currentStep, (newStep) => {
  announceStepChange(newStep)

  if (newStep >= dmlSteps.length) {
    pause()
  }
})

// ============================================================================
// LIFECYCLE
// ============================================================================
onMounted(() => {
  // Auto-play when component enters viewport
  useAutoPlay(containerRef, () => {
    setTimeout(() => {
      play()
    }, 500)
  })
})

onUnmounted(() => {
  if (animationTimerRef.value) {
    clearInterval(animationTimerRef.value)
  }
  if (announceTimeout.value) {
    clearTimeout(announceTimeout.value)
  }
})
</script>

<style scoped>
.unit-of-work-animation {
  width: 100%;
  max-width: 1200px;
  margin: 2rem auto;
  padding: 1.5rem;
  background: #0f0f1a;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.unit-of-work-animation:focus-visible {
  outline: 2px solid #0092c8;
  outline-offset: 4px;
}

/* Screen reader only class */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

/* Header */
.animation-header {
  text-align: center;
  margin-bottom: 1.5rem;
}

.animation-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.95);
  margin: 0 0 0.5rem 0;
}

.animation-subtitle {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
}

/* Content Grid */
.content-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
  margin: 1rem 0;
}

@media (min-width: 768px) {
  .content-grid {
    grid-template-columns: 2fr 1fr;
  }
}

.graph-section {
  min-height: 400px;
}

.table-section {
  min-height: 200px;
}

/* Keyboard Help */
.keyboard-help {
  margin-top: 1.5rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 8px;
}

.help-summary {
  cursor: pointer;
  font-size: 0.875rem;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
  user-select: none;
  list-style: none;
}

.help-summary::-webkit-details-marker {
  display: none;
}

.help-summary:hover {
  color: rgba(255, 255, 255, 0.9);
}

.help-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 0.75rem;
  margin: 1rem 0 0 0;
  padding: 0;
}

.help-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.help-item dt {
  padding: 0.25rem 0.5rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  font-size: 0.75rem;
  font-family: monospace;
  color: rgba(255, 255, 255, 0.9);
  white-space: nowrap;
}

.help-item dd {
  margin: 0;
  font-size: 0.813rem;
  color: rgba(255, 255, 255, 0.6);
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .unit-of-work-animation {
    padding: 1rem;
    margin: 1rem auto;
  }

  .animation-header {
    margin-bottom: 1rem;
  }

  .animation-title {
    font-size: 1.125rem;
  }

  .animation-subtitle {
    font-size: 0.813rem;
  }

  .content-grid {
    gap: 0.75rem;
  }

  .graph-section {
    min-height: 300px;
  }

  .keyboard-help {
    margin-top: 1rem;
    padding: 0.75rem;
  }

  .help-list {
    grid-template-columns: 1fr;
    gap: 0.5rem;
  }
}

@media (max-width: 640px) {
  .animation-title {
    font-size: 1rem;
  }

  .animation-subtitle {
    font-size: 0.75rem;
  }
}
</style>
