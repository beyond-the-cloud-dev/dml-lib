<template>
  <div class="dml-table-container">
    <h3 class="table-title">DML Execution</h3>
    <div class="table-scroll">
      <div
        v-for="(step, index) in steps"
        :key="step.step"
        class="table-row"
        :class="{
          completed: index < currentStep,
          active: index === currentStep,
          pending: index > currentStep,
          clickable: true
        }"
        role="button"
        tabindex="0"
        :aria-label="`Jump to step ${step.step}: ${step.operation} ${step.sobject}`"
        @click="handleStepClick(index)"
        @keydown.enter="handleStepClick(index)"
        @keydown.space.prevent="handleStepClick(index)"
      >
        <div class="step-indicator">
          <span v-if="index < currentStep" class="checkmark">✓</span>
          <span v-else>{{ step.step }}</span>
        </div>
        <div class="operation-badge" :class="getBadgeClass(step.operation)">
          {{ step.operation }}
        </div>
        <div class="sobject-label">
          {{ step.sobject }}
        </div>
        <div class="record-count" v-if="step.records.length > 1">
          ×{{ step.records.length }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  steps: {
    type: Array,
    required: true
  },
  currentStep: {
    type: Number,
    required: true
  }
})

const emit = defineEmits(['step-click'])

function handleStepClick(index) {
  emit('step-click', index)
}

function getBadgeClass(operation) {
  return operation.toLowerCase() === 'insert' ? 'op-insert' : 'op-upsert'
}
</script>

<style scoped>
.dml-table-container {
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  padding: 0.75rem;
}

.table-title {
  font-size: 0.875rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.7);
  margin: 0 0 0.75rem 0;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.table-scroll {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
  max-height: 400px;
  overflow-y: auto;
  padding-right: 0.25rem;
}

/* Custom scrollbar */
.table-scroll::-webkit-scrollbar {
  width: 6px;
}

.table-scroll::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.02);
  border-radius: 3px;
}

.table-scroll::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.table-scroll::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.15);
}

.table-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem;
  border-radius: 6px;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
}

.table-row.pending {
  background: rgba(255, 255, 255, 0.02);
  opacity: 0.4;
}

.table-row.active {
  background: rgba(255, 255, 255, 0.1);
  opacity: 1;
  box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.2);
}

.table-row.completed {
  background: rgba(34, 197, 94, 0.05);
  opacity: 0.8;
}

.table-row.clickable:hover {
  opacity: 1;
  transform: translateX(2px);
}

.table-row.clickable:focus-visible {
  outline: 2px solid #0092c8;
  outline-offset: 2px;
}

.table-row.clickable:active {
  transform: translateX(0);
}

.step-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1.75rem;
  height: 1.75rem;
  flex-shrink: 0;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 600;
  transition: all 0.4s ease;
}

.table-row.active .step-indicator {
  background: rgba(255, 255, 255, 0.9);
  color: #1a1a1a;
}

.table-row.completed .step-indicator {
  background: rgba(34, 197, 94, 0.3);
  color: #22c55e;
}

.checkmark {
  font-size: 0.875rem;
}

.operation-badge {
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.688rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.025em;
  flex-shrink: 0;
}

.op-insert {
  background: rgba(59, 130, 246, 0.2);
  color: #3b82f6;
}

.op-upsert {
  background: rgba(251, 146, 60, 0.2);
  color: #fb923c;
}

.sobject-label {
  font-size: 0.813rem;
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
  flex-grow: 1;
}

.record-count {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.5);
  margin-left: auto;
  flex-shrink: 0;
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .dml-table-container {
    padding: 0.625rem;
  }

  .table-title {
    font-size: 0.813rem;
    margin-bottom: 0.625rem;
  }

  .table-scroll {
    max-height: 300px;
  }

  .table-row {
    padding: 0.375rem;
    gap: 0.375rem;
  }

  .step-indicator {
    width: 1.5rem;
    height: 1.5rem;
    font-size: 0.688rem;
  }

  .operation-badge {
    font-size: 0.625rem;
    padding: 0.188rem 0.375rem;
  }

  .sobject-label {
    font-size: 0.75rem;
  }

  .record-count {
    font-size: 0.688rem;
  }
}
</style>
