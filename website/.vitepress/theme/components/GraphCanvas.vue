<template>
  <div class="graph-canvas">
    <svg
      viewBox="0 0 100 100"
      preserveAspectRatio="xMidYMid meet"
      class="graph-svg"
      role="img"
      :aria-label="`Dependency graph showing ${nodes.length} records and ${edges.length} relationships`"
    >
      <!-- Define arrow marker for edges -->
      <defs>
        <marker
          id="arrowhead"
          markerWidth="6"
          markerHeight="6"
          refX="5"
          refY="3"
          orient="auto"
        >
          <polygon
            points="0 0, 6 3, 0 6"
            fill="rgba(255, 255, 255, 0.2)"
          />
        </marker>
        <marker
          id="arrowhead-active"
          markerWidth="6"
          markerHeight="6"
          refX="5"
          refY="3"
          orient="auto"
        >
          <polygon
            points="0 0, 6 3, 0 6"
            fill="rgba(255, 255, 255, 0.5)"
          />
        </marker>
        <marker
          id="arrowhead-done"
          markerWidth="6"
          markerHeight="6"
          refX="5"
          refY="3"
          orient="auto"
        >
          <polygon
            points="0 0, 6 3, 0 6"
            fill="rgba(34, 197, 94, 0.5)"
          />
        </marker>

        <!-- Glow filter for active nodes -->
        <filter id="glow">
          <feGaussianBlur stdDeviation="0.8" result="coloredBlur"/>
          <feMerge>
            <feMergeNode in="coloredBlur"/>
            <feMergeNode in="SourceGraphic"/>
          </feMerge>
        </filter>
      </defs>

      <!-- Render edges first (behind nodes) -->
      <g class="edges-layer">
        <line
          v-for="edge in edges"
          :key="`${edge.from}-${edge.to}`"
          :x1="getPosition(edge.from).x"
          :y1="getPosition(edge.from).y"
          :x2="getPosition(edge.to).x"
          :y2="getPosition(edge.to).y"
          :class="['edge', getEdgeClass(edge)]"
          :stroke="getEdgeColor(edge)"
          stroke-width="0.3"
          :marker-end="getMarkerUrl(edge)"
          role="graphics-symbol"
          :aria-label="`Relationship: ${edge.from} ${edge.label} points to ${edge.to}`"
          @mouseenter="$emit('edge-hover', edge)"
          @mouseleave="$emit('edge-leave')"
        />
      </g>

      <!-- Render nodes -->
      <g class="nodes-layer">
        <g
          v-for="node in nodes"
          :key="node.id"
          class="node-group"
          :class="getNodeClass(node)"
          role="graphics-symbol"
          :aria-label="`${node.name}: ${node.type} record, ${getNodeState(node.id)} state`"
          tabindex="0"
          @click="$emit('node-click', node.id)"
          @mouseenter="$emit('node-hover', node.id)"
          @mouseleave="$emit('node-leave')"
          @keydown.enter="$emit('node-click', node.id)"
          @keydown.space.prevent="$emit('node-click', node.id)"
        >
          <!-- Outer glow ring for active nodes -->
          <circle
            v-if="isNodeActive(node.id)"
            :cx="getPosition(node.id).x"
            :cy="getPosition(node.id).y"
            r="4"
            fill="none"
            :stroke="node.color"
            stroke-width="0.4"
            opacity="0.5"
            class="pulse-ring"
          />

          <!-- Main node circle -->
          <circle
            :cx="getPosition(node.id).x"
            :cy="getPosition(node.id).y"
            r="2.5"
            :fill="getNodeFill(node)"
            :opacity="getNodeOpacity(node.id)"
            :filter="isNodeActive(node.id) ? 'url(#glow)' : 'none'"
            class="node-circle"
          />

          <!-- Node label -->
          <text
            :x="getPosition(node.id).x"
            :y="getPosition(node.id).y + 4.5"
            text-anchor="middle"
            font-size="2"
            :fill="getNodeLabelColor(node.id)"
            class="node-label"
          >
            {{ getNodeLabel(node.id) }}
          </text>
        </g>
      </g>
    </svg>

    <!-- Legend -->
    <div class="legend">
      <div class="legend-item">
        <div class="legend-dot" style="background: #4ade80"></div>
        <span>Account</span>
      </div>
      <div class="legend-item">
        <div class="legend-dot" style="background: #06b6d4"></div>
        <span>Contact</span>
      </div>
      <div class="legend-item">
        <div class="legend-dot" style="background: #a855f7"></div>
        <span>Opportunity</span>
      </div>
      <div class="legend-item">
        <div class="legend-dot" style="background: #ef4444"></div>
        <span>Lead</span>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  nodes: {
    type: Array,
    required: true
  },
  edges: {
    type: Array,
    required: true
  },
  nodePositions: {
    type: Map,
    required: true
  },
  nodeStates: {
    type: Map,
    required: true
  },
  activeEdges: {
    type: Array,
    default: () => []
  }
})

defineEmits(['node-click', 'node-hover', 'node-leave', 'edge-hover', 'edge-leave'])

function getPosition(nodeId) {
  return props.nodePositions.get(nodeId) || { x: 50, y: 50 }
}

function getNodeState(nodeId) {
  return props.nodeStates.get(nodeId)?.state || 'pending'
}

function isNodeActive(nodeId) {
  return getNodeState(nodeId) === 'active'
}

function isNodeDone(nodeId) {
  return getNodeState(nodeId) === 'done'
}

function getNodeClass(node) {
  const state = getNodeState(node.id)
  return `node-${state}`
}

function getNodeFill(node) {
  const state = getNodeState(node.id)
  if (state === 'pending') return 'rgba(255, 255, 255, 0.1)'
  return node.color
}

function getNodeOpacity(nodeId) {
  const state = getNodeState(nodeId)
  if (state === 'pending') return 0.3
  if (state === 'active') return 1
  if (state === 'done') return 0.8
  return 0.3
}

function getNodeLabelColor(nodeId) {
  const state = getNodeState(nodeId)
  if (state === 'pending') return 'rgba(255, 255, 255, 0.25)'
  if (state === 'active' || state === 'done') return 'rgba(255, 255, 255, 0.9)'
  return 'rgba(255, 255, 255, 0.25)'
}

function getNodeLabel(nodeId) {
  return nodeId
    .replace('account', 'A')
    .replace('contact', 'C')
    .replace('opportunity', 'O')
    .replace('lead', 'L')
}

function isEdgeActive(edge) {
  return props.activeEdges.some(
    e => e.from === edge.from && e.to === edge.to
  )
}

function isEdgeDone(edge) {
  return isNodeDone(edge.from) && isNodeDone(edge.to)
}

function getEdgeClass(edge) {
  if (isEdgeActive(edge)) return 'edge-active'
  if (isEdgeDone(edge)) return 'edge-done'
  return 'edge-pending'
}

function getEdgeColor(edge) {
  if (isEdgeActive(edge)) return 'rgba(255, 255, 255, 0.4)'
  if (isEdgeDone(edge)) return 'rgba(34, 197, 94, 0.3)'
  return 'rgba(255, 255, 255, 0.08)'
}

function getMarkerUrl(edge) {
  if (isEdgeActive(edge)) return 'url(#arrowhead-active)'
  if (isEdgeDone(edge)) return 'url(#arrowhead-done)'
  return 'url(#arrowhead)'
}
</script>

<style scoped>
.graph-canvas {
  position: relative;
  width: 100%;
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  padding: 1rem;
}

.graph-svg {
  width: 100%;
  height: auto;
  aspect-ratio: 1 / 0.7;
  display: block;
}

/* Edge transitions */
.edge {
  transition: all 0.4s ease-in-out;
}

.edge-active {
  stroke-dasharray: 2 1;
  animation: dash-flow 1s linear infinite;
}

@keyframes dash-flow {
  to {
    stroke-dashoffset: -3;
  }
}

/* Node transitions */
.node-group {
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.node-group:hover .node-circle {
  r: 3;
}

.node-group:focus-visible {
  outline: 2px solid #0092c8;
  outline-offset: 2px;
}

.node-circle {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.node-label {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 500;
  pointer-events: none;
}

/* Pulse animation for active nodes */
.pulse-ring {
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% {
    r: 4;
    opacity: 0.5;
  }
  50% {
    r: 5;
    opacity: 0.2;
  }
}

/* Legend */
.legend {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 1rem;
  margin-top: 1rem;
  padding-top: 0.75rem;
  border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.6);
}

.legend-dot {
  width: 0.625rem;
  height: 0.625rem;
  border-radius: 50%;
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .graph-canvas {
    padding: 0.75rem;
  }

  .legend {
    gap: 0.75rem;
    margin-top: 0.75rem;
  }

  .legend-item {
    font-size: 0.688rem;
  }
}
</style>
