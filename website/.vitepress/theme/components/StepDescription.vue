<template>
  <div
    class="step-description"
    :class="[stateClass]"
  >
    <div v-if="stepInfo.operation" class="step-header">
      <div class="step-number">{{ stepInfo.stepNumber || '' }}</div>
      <div class="step-meta">
        <span class="operation-badge" :class="operationClass">
          {{ stepInfo.operation }}
        </span>
        <span class="sobject-name">{{ stepInfo.sobject }}</span>
        <span v-if="stepInfo.recordCount > 1" class="record-count">
          × {{ stepInfo.recordCount }}
        </span>
      </div>
    </div>

    <div class="step-content">
      <h3 class="step-title">{{ stepInfo.title }}</h3>
      <p class="step-text">{{ stepInfo.description }}</p>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  stepInfo: {
    type: Object,
    required: true,
    validator: (value) => {
      return (
        typeof value.title === 'string' &&
        typeof value.description === 'string'
      )
    }
  }
})

const stateClass = computed(() => {
  if (!props.stepInfo.operation) return 'state-idle'
  if (props.stepInfo.title.includes('Complete')) return 'state-complete'
  return 'state-active'
})

const operationClass = computed(() => {
  const operation = props.stepInfo.operation
  if (!operation) return ''
  return operation.toLowerCase() === 'insert' ? 'op-insert' : 'op-upsert'
})
</script>

<style scoped>
.step-description {
  padding: 1rem;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(255, 255, 255, 0.02);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.step-description.state-idle {
  background: rgba(255, 255, 255, 0.02);
  border-color: rgba(255, 255, 255, 0.05);
}

.step-description.state-active {
  background: rgba(255, 255, 255, 0.03);
  border-color: rgba(255, 255, 255, 0.1);
}

.step-description.state-complete {
  background: rgba(34, 197, 94, 0.1);
  border-color: rgba(34, 197, 94, 0.2);
}

.step-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
}

.step-number {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  flex-shrink: 0;
}

.state-complete .step-number {
  background: rgba(34, 197, 94, 0.3);
  color: #22c55e;
}

.state-complete .step-number::after {
  content: '✓';
}

.step-meta {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.operation-badge {
  padding: 0.25rem 0.625rem;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.025em;
}

.op-insert {
  background: rgba(59, 130, 246, 0.2);
  color: #3b82f6;
}

.op-upsert {
  background: rgba(251, 146, 60, 0.2);
  color: #fb923c;
}

.sobject-name {
  font-size: 0.875rem;
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
}

.record-count {
  font-size: 0.813rem;
  color: rgba(255, 255, 255, 0.5);
  font-weight: 400;
}

.step-content {
  padding-left: 0;
}

.step-title {
  font-size: 0.875rem;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 0.5rem 0;
}

.step-text {
  font-size: 0.813rem;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.6);
  margin: 0;
}

.state-idle .step-title {
  color: rgba(255, 255, 255, 0.6);
}

.state-idle .step-text {
  color: rgba(255, 255, 255, 0.4);
}

.state-complete .step-title {
  color: #22c55e;
}

.state-complete .step-text {
  color: rgba(34, 197, 94, 0.8);
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .step-description {
    padding: 0.75rem;
  }

  .step-header {
    gap: 0.5rem;
    margin-bottom: 0.5rem;
  }

  .step-number {
    width: 1.75rem;
    height: 1.75rem;
    font-size: 0.75rem;
  }

  .operation-badge {
    font-size: 0.688rem;
    padding: 0.188rem 0.5rem;
  }

  .sobject-name {
    font-size: 0.813rem;
  }

  .step-title {
    font-size: 0.813rem;
  }

  .step-text {
    font-size: 0.75rem;
  }
}
</style>
