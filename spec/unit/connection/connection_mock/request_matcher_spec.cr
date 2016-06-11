require "../../../spec_helper"

Spec2.describe Cossack::TestConnection::RequestMatcher do
  let(request_headers) { HTTP::Headers.new.tap { |h| h["User-Agent"] = "Cossack" } }
  let(request) { Cossack::Request.new("POST", URI.parse("https://esperanto.org/vortaro/vivo?to=en"), request_headers, "The love") }

  let(matcher) { Cossack::TestConnection::RequestMatcher.new(method, url, headers, body) }
  let(method) { nil }
  let(url) { nil}
  let(headers) { {} of String => String }
  let(body) { nil }

  describe "#matches?" do
    subject { matcher.matches?(request) }

    context "when nothing is specified" do
      it "returns true" do
        expect(matcher.matches?(request)).to eq true
      end
    end

    context "when method is specified" do
      context "when method does not match" do
        let(method) { "GET" }
        it "returns false" { expect(subject).to eq false }
      end

      context "when method matches" do
        let(method) { "POST" }
        it "returns true" { expect(subject).to eq true }

        context "when URL is specified" do
          context "when URL does not match" do
            let(url) { "https://esperanto.org/other/path" }
            it "returns false" { expect(subject).to eq false }

            context "when only path is specified" do
              let(url) { "/other/path" }
              it "returns false" { expect(subject).to eq false }
            end

            context "when path and query are specified" do
              let(url) { "/vortaro/vivo?to=ru" }
              it "returns false" { expect(subject).to eq false }
            end

            context "when scheme does not match" do
              let(url) { "http://esperanto.org/vortaro/vivo?to=en" }
              it "returns false" { expect(subject).to eq false }
            end
          end

          context "when URL matches" do
            let(url) { "https://esperanto.org/vortaro/vivo?to=en" }
            it "returns true" { expect(subject).to eq true }

            context "when only path is specified" do
              let(url) { "/vortaro/vivo" }
              it "returns true" { expect(subject).to eq true }
            end

            context "when headers are given" do
              context "when one of headers do not match" do
                let(headers) { { "User-Agent" => "Firefox" } }
                it "returns false" { expect(subject).to eq false }
              end

              context "when all headers match" do
                let(headers) { { "User-Agent" => "Cossack" } }
                it "returns true" { expect(subject).to eq true }

                context "when body is specified" do
                  context "when body does not match" do
                    let(body) { "The hate" }
                    it "returns false" { expect(subject).to eq false }
                  end

                  context "when body matches" do
                    let(body) { "The love" }
                    it "returns true" { expect(subject).to eq true}
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
