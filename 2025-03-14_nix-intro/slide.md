---
marp: true
theme: uncover
_class: lead
paginate: true
style: div.mermaid { all: unset; }
---

# Nix
#### —環境の構築について—

yuki @lmdexpr
2025-03-14

---

# にx
#### —環境の構築について—

yuki @lmdexpr
2025-03-14

---

<!-- header: "Nix —環境の構築について— @lmdexpr" --->

## 自己紹介

- Yuki Tajiri (@lmdexpr)
- 2025-02 より M3 基盤チームでソフトウェアエンジニア
- 関数型プログラミング（言語）が好き
- 6月14日〜6月15日に開催予定の「関数型まつり 2025」で僕と握手！

---

## こんな経験はありませんか
- 「新しく参加した PJ で丸一日環境構築に使った」
- 「自分の環境では動いているのにQA環境で動かない」
- 「インストールスクリプトが動かなくなっていた」
- 「何もしてないのに壊れました」

---

## なぜこんなことが起きるのか

---

## ラプラスの魔

> もしもある瞬間における全ての物質の力学的状態と力を知ることができ、かつもしもそれらのデータを解析できるだけの能力の知性が存在するとすれば、この知性にとっては、不確実なことは何もなくなり、その目には未来も（過去同様に）全て見えているであろう。
— 『確率の解析的理論』1812年

---

## コンピュータの中に<br>ラプラスの魔がいてくれればなあ〜

---

# Nix

---

## Nix

> Nix, the purely functional package manager

- **純粋関数型**パッケージマネージャー
  - Linux ディストリビューション
  - プログラミング言語
  - ...
- 三つのコンセプト
  - Reproducible / Declarative / Reliable

---

## Reproducible
> Nix builds packages in isolation from each other. This ensures that they are reproducible and don’t have undeclared dependencies, so if a package works on one machine, it will also work on another.

Nix は独立してパッケージをビルドします。これにより、パッケージの再現性と未宣言の依存がないことを保証します。あるマシンで動作するなら、他のマシンでも動作するでしょう。

---

## Reproducible

Nix のビルド

<div class="mermaid">
%%{init: {"flowchart": {"htmlLabels": false}} }%%
flowchart LR
    subgraph Inputs
        inputs("
        シェル
        環境変数
        依存パッケージ
        ソースコード
        ...
        ")
    end
    subgraph Sandbox
        build(("ビルド実行"))
    end
    subgraph Outputs
        output("成果物")
    end
    Inputs --> Sandbox --> Outputs
    subgraph Hostmachine["ホストの環境"]
        Files["ファイル"]
        HostEnv["環境変数"]
    end
    Internet["インターネット"]
    Sandbox <-.->|アクセスできない| Internet
    Hostmachine <-.->|アクセスできない| Sandbox
</div>

<script type="module">
import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10.0.0/dist/mermaid.esm.min.mjs';
mermaid.initialize({ startOnLoad: true });
window.addEventListener('vscode.markdown.updateContent', function() { mermaid.init() });
</script>

---

## Declarative
> Nix makes it trivial to share development and build environments for your projects, regardless of what programming languages and tools you’re using.

Nix はどんなプログラミング言語、ツールを使っているかを問わず、プロジェクトの開発環境やビルドを簡単に共有させます。

---

## Declarative

<div class="mermaid">
%%{init: {"flowchart": {"htmlLabels": false}} }%%
flowchart LR
    subgraph Nix["Nix言語"]
        nixbuild["build.nix"]
        nixdevelop["develop.nix"]
    end
    subgraph NixStore["Nixストア"]
        subgraph Derivation
            subgraph Inputs
                subgraph Closures
                    otherDerivs("
                    依存 Derivation A
                    依存 Derivation B
                    ...
                    ")
                end
                others("
                builder(シェル)
                環境変数
                ...
                ")
            end
            subgraph Outputs
                output("出力先")
            end
        end
        storeobj("ストアオブジェクト")
    end
    nixbuild -.->|Instantiation| Derivation -.->|Realisation| storeobj
    nixdevelop -.->|nix develop| Shell["指定されたパッケージや設定などが入ったシェル"]
</div>

<script type="module">
import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10.0.0/dist/mermaid.esm.min.mjs';
mermaid.initialize({ startOnLoad: true });
window.addEventListener('vscode.markdown.updateContent', function() { mermaid.init() });
</script>

---

## Reliable
> Nix ensures that installing or upgrading one package cannot break other packages. It allows you to roll back to previous versions, and ensures that no package is in an inconsistent state during an upgrade.

Nix はパッケージのインストールやアップグレードが他のパッケージを壊さないようにします。以前の環境にロールバックすることやアップグレード時に不整合な状態が生まれないようにします。

---

## Reliable

- インストール時に作成される /nix/store 配下の色々
- パッケージはストアオブジェクトとして配置される
- 例: `/nix/store/sglc12hc6pc68w5ppn2k56n6jcpaci16-my-package-1.0`

---

## Reliable

<div class="mermaid">
%%{init: {"flowchart": {"htmlLabels": false}} }%%
flowchart LR
    subgraph NixStore["Nixストア"]
        subgraph Derivation
            subgraph Inputs
                subgraph Closures
                    otherDerivs("
                    依存 Derivation A
                    依存 Derivation B
                    ...
                    ")
                end
                others("
                builder(シェル)
                環境変数
                ...
                ")
            end
        end
        Outputs["ストアオブジェクト
        hash-package_name
        "]
    end
    subgraph Sandbox
        build(("ビルド実行"))
    end
    Inputs --> Sandbox --> Outputs
    Inputs -->|ハッシュを計算| hash["＜hash＞-＜package＞-＜version＞"] --> Outputs
    subgraph Profile
        subgraph ProfileA
            linksA["シェル、パッケージ、..."]
        end
        subgraph ProfileB
            linksB["シェル、パッケージ、..."]
        end
    end
    Outputs -.->|シンボリックリンク| linksA
    Outputs -.->|シンボリックリンク| linksB
</div>

<script type="module">
import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10.0.0/dist/mermaid.esm.min.mjs';
mermaid.initialize({ startOnLoad: true });
window.addEventListener('vscode.markdown.updateContent', function() { mermaid.init() });
</script>

---

## Reliable

- ハッシュさえあればバイナリキャッシュできる
    - 再現性は担保されている
- 実際の利用の際にはシンボリックリンクを多段に使用するのでロールバックは昔の環境と同じリンクに戻すだけで戻る

---

# Try it

- おすすめのチュートリアル
  - https://zero-to-nix.com/
  - nix のインストールには root が必要です
  (`/nix`が必要なため)
- nix-portable
  - https://github.com/DavHau/nix-portable
  - rootless でインストールできる nix
  - （使ったことなし）

---

今回のオチ

---

次回
## 「NixOS、死す」

そこにあるはずの共有ライブラリを
ぽん置きバイナリが参照してくれない件について

〜え、しかも、ストレージ容量が残り 3GB！？〜
