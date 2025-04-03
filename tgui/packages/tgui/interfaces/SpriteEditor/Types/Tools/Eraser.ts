import { useBackend } from '../../../../backend';
import { parseHexColorString } from '../../colorSpaces';
import { constrainToIconGrid, copyLayer, getDataPixel } from '../../helpers';
import { Tool } from '../Tool';
import { LayerTransaction } from '../Transaction';
import {
  Dir,
  SpriteData,
  SpriteEditorContextType,
  StringLayer,
} from '../types';

class EraserTransaction implements LayerTransaction {
  name = 'Eraser';
  layer: number;
  dir: Dir;
  points: Map<string, [number, number]> = new Map();

  constructor(dir: Dir, layer: number) {
    this.dir = dir;
    this.layer = layer;
  }

  addPoint(x: number, y: number, color: string) {
    const hashKey = `${x},${y}`;
    if (this.points.has(hashKey)) return;
    if (parseHexColorString(color).a === 0) return;
    this.points.set(`${x},${y}`, [x, y]);
  }

  getPreviewLayer(layer: StringLayer) {
    const outLayer = copyLayer(layer);
    this.points.values().forEach(([x, y]) => (outLayer[y][x] = '#00000000'));
    return outLayer;
  }

  commit() {
    const { act } = useBackend();
    act('spriteEditorCommand', {
      command: 'transaction',
      transaction: {
        type: 'eraser',
        name: 'Eraser',
        layer: this.layer + 1,
        dir: `${this.dir}`,
        points: this.points.values().toArray(),
      },
    });
  }
}

export class Eraser extends Tool {
  icon = 'eraser';
  name = 'Eraser';
  currentTransaction: EraserTransaction | null;
  onMouseDown(
    context: SpriteEditorContextType,
    data: SpriteData,
    x: number,
    y: number,
    isRightClick: boolean,
  ) {
    const { selectedDir, selectedLayer, setPreviewLayer, setPreviewData } =
      context;
    const { width, height, layers } = data;
    const [px, py, inBounds] = constrainToIconGrid(x, y, width, height);
    if (!inBounds || isRightClick) return;
    this.currentTransaction = new EraserTransaction(selectedDir, selectedLayer);
    this.currentTransaction.addPoint(
      px,
      py,
      getDataPixel(data, selectedLayer, selectedDir, px, py),
    );
    setPreviewLayer(selectedLayer);
    setPreviewData(
      this.currentTransaction.getPreviewLayer(
        layers[selectedLayer].data[selectedDir]!,
      ),
    );
    return true;
  }
  onMouseMove(
    context: SpriteEditorContextType,
    data: SpriteData,
    x: number,
    y: number,
  ) {
    const { selectedDir, selectedLayer, setPreviewData } = context;
    const { width, height, layers } = data;
    const { currentTransaction } = this;
    const { dir, layer } = currentTransaction!;
    const [px, py, inBounds] = constrainToIconGrid(x, y, width, height);
    if (!inBounds) return;
    currentTransaction!.addPoint(
      px,
      py,
      getDataPixel(data, selectedLayer, selectedDir, px, py),
    );
    setPreviewData(
      currentTransaction!.getPreviewLayer(layers[layer].data[dir]!),
    );
  }
  onMouseUp(
    context: SpriteEditorContextType,
    data: SpriteData,
    x: number,
    y: number,
  ) {
    const { setPreviewLayer, setPreviewData } = context;
    setPreviewLayer(undefined);
    setPreviewData(undefined);
    this.currentTransaction!.commit();
    this.currentTransaction = null;
  }
}
