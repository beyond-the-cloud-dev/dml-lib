<template>
  <div class="progress-bar-container">
    <div
      class="progress-bar-track"
      role="progressbar"
      :aria-valuenow="current"
      :aria-valuemin="0"
      :aria-valuemax="total"
      :aria-valuetext="`Step ${current} of ${total}`"
    >
      <div class="progress-steps">
        <div
          v-for="(_, index) in total"
          :key="index"
          class="progress-step"
          :class="{
            completed: index < current,
            active: index === current,
            pending: index > current
          }"
          :title="`Step ${index + 1}`"
        />
      </div>
      <div
        class="progress-fill"
        :style="{ width: `${progressPercentage}%` }"
      />
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  current: {
    type: Number,
    required: true
  },
  total: {
    type: Number,
    required: true
  }
})

const progressPercentage = computed(() => {
  if (props.total === 0) return 0
  return (props.current / props.total) * 100
})
</script>

<style scoped>
.progress-bar-container {
  width: 100%;
  padding: 0.5rem 0;
  display: flex;
  justify-content: center;
}

.progress-bar-track {
  position: relative;
  width: 100%;
  max-width: 500px;
  height: 8px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 4px;
  overflow: visible;
}

.progress-steps {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  gap: 2px;
  padding: 0 1px;
}

.progress-step {
  flex: 1;
  height: 4px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 2px;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.progress-step.completed {
  background: rgba(34, 197, 94, 0.7);
  height: 6px;
}

.progress-step.active {
  background: rgba(255, 255, 255, 0.9);
  height: 8px;
  box-shadow: 0 0 8px rgba(255, 255, 255, 0.5);
}

.progress-step.pending {
  background: rgba(255, 255, 255, 0.1);
  height: 4px;
}

.progress-fill {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  background: linear-gradient(
    90deg,
    rgba(34, 197, 94, 0.3) 0%,
    rgba(0, 146, 200, 0.4) 100%
  );
  border-radius: 4px;
  transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  pointer-events: none;
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .progress-bar-track {
    height: 6px;
  }

  .progress-step {
    height: 3px;
  }

  .progress-step.completed {
    height: 5px;
  }

  .progress-step.active {
    height: 6px;
  }

  .progress-steps {
    gap: 1px;
  }
}
</style>
